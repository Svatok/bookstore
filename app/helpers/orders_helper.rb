module OrdersHelper
  SORTING = { in_waiting: 'Waiting for processing',
              in_progress: 'In progress',
              in_delivery: 'In delivery',
              delivered: 'Delivered',
            }

  def current_sort(sort)
    sort.present? ? SORTING[sort.to_sym] : SORTING[:in_waiting]
  end

end
