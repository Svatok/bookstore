ActiveAdmin.register Product do

  permit_params :id, :title, :description, :category_id, :product_type, :status
  decorate_with ProductDecorator

  scope 'Products', :main, default: true
  scope :coupons
  scope :shippings
  filter :select_product_type, label: 'Product status', as: :select, collection: ['active', 'inactive']
  filter :with_category, label: 'Category', as: :select, collection: Category.select(:name, :id).to_a


  index :as => ActiveAdmin::Views::IndexAsTable do
    selectable_column
    column :image do |product|
      image_tag(product.pictures_path_array.first, width: '50')
    end
    column 'Category', :sortable => 'categories.name' do |product|
      product.category if product.category.present?
    end
    column 'Title', :sortable => :title do |product|
      product.title
    end
    column 'Authors', :sortable => false do |product|
      product.all_authors
    end
    column 'Short description', :sortable => :description do |product|
      truncate(product.description, length: 100)
    end
    column 'Price', :sortable => false do |product|
      number_to_currency(product.price_value,:unit=>'€')
    end
    column 'Status', :sortable => :status do |product|
      product.status
    end
    actions
  end

  show do
    render 'show'
  end

  form partial: 'form'

  controller do
    def scoped_collection
      resource_class.includes(:category).includes(:prices) # prevents N+1 queries to your database
    end

    def show
      @product = Product.find(params[:id]).decorate
    end

    def edit
      @product_form = ProductForm.new
      @product = Product.find(params[:id]).decorate
    end

    def update
      @product_form = ProductForm.from_params(params)
      @product = Product.find(params[:id]).decorate
      if @product_form.save?
        # @product_form.save
        add_pictures
#        product_update
        redirect_back(fallback_location: root_path)
      else
        render :edit
      end
    end

    private

    def product_update
      @product.update_attributes(product_params)
      @product.prices.create(value: params['product']['price'], date_start: Date.today.to_s) unless @product.price_value == params['product']['price'].to_f
      @product.stocks.create(value: params['product']['stock'], date_start: Date.today.to_s) unless @product.stock_value == params['product']['stock'].to_i
      add_pictures
      add_authors
      add_characteristics
    end

    def add_pictures
      return unless params['product_attachments'].present?
      params['product_attachments']['picture'].each do |picture|
        @product.pictures.create(image_path: picture)
      end
    end

    def add_authors
      return unless params['product']['authors'].present?
      params['product']['authors'].each do |author_id|
        author = Author.find_by_id(author_id)
        next if @product.authors.include?(author)
        @product.authors << author
      end
    end

    def add_characteristics
      return unless params['product']['characteristics'].present?
      params['product']['characteristics'].each do |id, value|
        next if value['value'] == ''
        characteristic = @product.characteristics.find_or_initialize_by(property_id: value['property_id'])
        characteristic.value = value['value']
        characteristic.save
      end
    end

    def product_params
      params.require(:product).permit(:title, :description)
    end
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
