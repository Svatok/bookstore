class AddDefaultStateToOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :state, :string, default: 'cart'
  end
end
