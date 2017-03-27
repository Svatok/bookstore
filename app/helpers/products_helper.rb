module ProductsHelper
  SORTING = { newest: 'Newest first',
              popular: 'Popular first',
              price_asc: 'Price: Low to hight',
              price_desc: 'Price: Hight to low',
              title_asc: 'Title: A - Z',
              title_desc: 'Title: Z - A'
            }

  def current_sort(sort)
    sort.present? ? SORTING[sort.to_sym] : SORTING[:newest]
  end
end
