class ProductDecorator < Draper::Decorator
  delegate_all

  def all_authors
    return '' unless object.authors.present?
    object.authors.collect { |author| author.first_name + ' ' + author.last_name }.join(', ')
  end

  def dimensions
    dimensions = {}
    object.characteristics.dimensions_value.each do |dimension|
      dimensions[dimension.property.name] = dimension.value
    end
    "H: #{dimensions['Height']}\" x W: #{dimensions['Width']}\" x D: #{dimensions['Depth']}\""
  end

  def property_value(property_name)
    characteristic = object.characteristics.property(property_name)
    return unless characteristic.present?
    characteristic.first.value
  end

  def price_value
    object.prices.present? ? object.prices.actual.first.value : 0.0
  end

  def stock_value
    object.stocks.present? ? object.stocks.actual.first.value : 0
  end

  def product_pictures(count = 15)
    object.pictures.present? ? object.pictures.product_imgs(count) : Picture.no_image
  end
end
