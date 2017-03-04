class AddPrevStateToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :prev_state, :string
  end
end
