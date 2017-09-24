ActiveAdmin.register Product do

  menu priority: 1
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
      image_tag(product.product_pictures(1).first.try(:image_path), width: '50')
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
      resource_class.includes(:category).includes(:prices)
    end

    def new
      @product_form = ProductForm.new
      @product = Product.new.decorate
    end

    def create
      @product_form = ProductForm.from_params(params)
      @product = Product.new.decorate
      if @product_form.save
        redirect_to admin_products_path
      else
        render :new
      end
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
      if @product_form.save
        redirect_back(fallback_location: root_path)
      else
        render :edit
      end
    end

    def destroy
      return delete_author if params['author'].present?
      super
    end

    def delete_author
      @product = Product.find(params[:id])
      @author = Author.find_by_id(params['author'])
      @product.authors.delete(@author)
      redirect_back(fallback_location: root_path)
    end

  end
end
