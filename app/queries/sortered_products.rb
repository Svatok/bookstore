class SorteredProducts < Rectify::Query
  def initialize(params)
    @params = params
    @params[:sort] = 'newest' unless @params[:sort].present?
    @page = @params[:page].present? ? @params[:page].to_i : 1
    @limit = 2
    @products = Product.in_stock
  end

  def query
    all.limit(@limit).offset(offset)
  end

  def current_page
    @page
  end

  def total_pages
    total = all.count
    (total.to_f / @limit).ceil
  end

  def limit_value
    @limit
  end

  def offset
    (@page - 1) * @limit
  end

  def next_page
    current_page + 1
  end

  private
    def all
      @products = @products.where(category: @params[:category]) if @params[:category].present?
      case @params[:sort]
      when 'newest'
        @products = @products.order(created_at: :desc)
      when 'popular'
        @products = @products.order(created_at: :desc)
      when 'price_asc'
        @products = @products.joins("INNER JOIN (SELECT a.* FROM prices as a
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
        @products = @products.joins("INNER JOIN (SELECT a.* FROM prices as a
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
        @products = @products.order(title: :asc)
      when 'title_desc'
        @products = @products.order(title: :desc)
      else
        @products
      end
  end

end
