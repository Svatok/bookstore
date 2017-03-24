module PaginationHelper
  def current_page
    @page
  end

  def total_pages
    total = all.to_a.size
    (total.to_f / @limit).ceil
  end

  def limit_value
    @limit
  end

  def offset
    (@page - 1) * @limit
  end

  def prev_page
    current_page - 1 unless first_page? || out_of_range?
  end

  def next_page
    current_page + 1 unless last_page? || out_of_range?
  end

  def first_page?
    current_page == 1
  end

  def last_page?
    current_page == total_pages
  end

  def out_of_range?
    current_page > total_pages
  end
end
