class ProductForm < Rectify::Form
  attribute :title, String
  attribute :description, String
  attribute :category, Integer
  attribute :status, String
  attribute :product_type, String
  attribute :price, Float
  attribute :stock, Integer
  attribute :product_attachments, Array
  attribute :authors, Array
  attribute :properties, Array
  attribute :characteristics, Array

  validates :title, presence: true, length: { minimum: 2 }
  validates :description, presence: true, length: { minimum: 10 }, if: :is_product?
  validates :category, presence: true, if: :is_product?
  validates :status, presence: true
  validates :product_type, presence: true
  validates :price, presence: true, numericality: { greater_than: 0.0 }, if: :is_product?
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: :is_product?
  validate :validate_characteristics

  def save
    return false unless valid?
    persist!
    true
  end

  def persist!
    @product = Product.find_by_id(id).present? ? Product.find_by_id(id) : Product.new
    @product.update_attributes(title: title, description: description, category_id: category, status: status, product_type: product_type)
    add_price
    add_stock
    add_authors
    add_characteristics
    add_pictures
  end
  
  private
  
  def validate_characteristics
    return unless characteristics.present?
    characteristics.each do |characteristic|
      errors.add(:characteristics, :invalid) unless characteristic['value'].present? && characteristic['property_id'].present?
    end
  end
  
  def add_price
    current_price = @product.prices.present? ? @product.prices.actual.first.value : 0.0
    @product.prices.create(value: price, date_start: Date.today.to_s) unless current_price == price.to_f    
  end

  def add_stock
    current_stock = @product.stocks.present? ? @product.stocks.actual.first.value : 0
    @product.stocks.create(value: stock, date_start: Date.today.to_s) unless current_stock == stock.to_i
  end
  
  def is_product?
    product_type == 'product'
  end

  def add_authors
    return unless authors.present?
    authors.each do |author_id|
      author = Author.find_by_id(author_id)
      next if @product.authors.include?(author)
      @product.authors << author
    end
  end

  def add_characteristics
    return unless characteristics.present?
    characteristics.each do |value|
      next if value['value'] == ''
      characteristic = @product.characteristics.find_or_initialize_by(property_id: value['property_id'])
      characteristic.update_attributes(value: value['value'])
    end
  end

  def add_pictures
    return unless product_attachments.present?
    product_attachments.each do |picture,value|
      @product.pictures.create(image_path: picture)
    end
  end
end
