module OrdersHelper
  SORTING = { in_waiting: 'Waiting for processing',
              in_progress: 'In progress',
              in_delivery: 'In delivery',
              delivered: 'Delivered',
            }

  def current_sort(sort)
    sort.present? ? SORTING[:in_waiting] : SORTING[sort.to_sym]
  end

end
