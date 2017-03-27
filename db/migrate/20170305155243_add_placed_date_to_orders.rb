class AddPlacedDateToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :placed_date, :date
  end
end
