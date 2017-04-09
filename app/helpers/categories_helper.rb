module CategoriesHelper

  def category_with_count(category = 'all')
    products_count = category == 'all' ? Product.in_stock.count : Product.with_category(category).count
    category_name = category == 'all' ? 'All' : Category.find(category).name
    category_name + ' (' + products_count.to_s + ')'
  end
end
