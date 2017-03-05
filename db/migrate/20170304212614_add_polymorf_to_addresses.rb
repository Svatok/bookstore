class AddPolymorfToAddresses < ActiveRecord::Migration[5.0]
  def change
    rename_column :addresses, :user_id, :addressable_id
    add_column :addresses, :addressable_type, :string
  end
end
