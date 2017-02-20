class SorteredProducts < Rectify::Query
  def initialize(sort)
    @sort = sort
  end

  def query
    case @sort
    when 'newest'
      Product.in_stock.order(created_at: :desc)
    when 'popular'
      Product.in_stock.order(created_at: :desc)
    when 'price_asc'
      Product.in_stock.joins("INNER JOIN (SELECT a.* FROM prices as a
                                    WHERE EXISTS (SELECT 1 FROM prices as b
                                                    WHERE a.priceable_id = b.priceable_id
                                                      AND a.priceable_type = b.priceable_type
                                                      AND b.priceable_type = 'Product'
                                                      AND b.date_start <= '#{Date.today}'
                                                    HAVING MAX(b.date_start) = a.date_start)
                                  ) as p
                                  ON products.id = p.priceable_id")
                      .order('p.value ASC')
    when 'price_desc'
      Product.in_stock.joins("INNER JOIN (SELECT a.* FROM prices as a
                                    WHERE EXISTS (SELECT 1 FROM prices as b
                                                    WHERE a.priceable_id = b.priceable_id
                                                      AND a.priceable_type = b.priceable_type
                                                      AND b.priceable_type = 'Product'
                                                      AND b.date_start <= '#{Date.today}'
                                                    HAVING MAX(b.date_start) = a.date_start)
                                  ) as p
                                  ON products.id = p.priceable_id")
                      .order('p.value DESC')
    when 'title_asc'
      Product.in_stock.order(title: :asc)
    when 'title_desc'
      Product.in_stock.order(title: :desc)
    else
      Product.in_stock
    end
  end
end
