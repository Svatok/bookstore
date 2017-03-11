class ProductForm < Rectify::Form
  attribute :title, String
  attribute :description, String
  attribute :price, Float
  attribute :stock, Integer
  attribute :product_attachments, Array
  attribute :authors, Array
  attribute :properties, Array
  attribute :characteristics, Array

  validates :title, presence: true, length: { minimum: 2 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :price, presence: true, numericality: { greater_than: 0.0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_characteristics

  def validate_characteristics
    return unless characteristics.present?
    characteristics.each do |characteristic|
      errors.add(:characteristics, :invalid) unless characteristic['value'].present? && characteristic['property_id'].present?
    end
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def persist!
    @product = Product.find_by_id(id)
    @product.update_attributes(title: title, description: description)
    current_price = @product.prices.present? ? @product.prices.actual.first.value : 0.0
    @product.prices.create(value: price, date_start: Date.today.to_s) unless current_price == price.to_f
    current_stock = @product.stocks.present? ? @product.stocks.actual.first.value : 0
    @product.stocks.create(value: stock, date_start: Date.today.to_s) unless current_stock == stock.to_i
    add_authors
    add_characteristics
    @product.save
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
      characteristic.value = value['value']
      characteristic.save
    end
  end

end
