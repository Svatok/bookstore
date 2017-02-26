class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :zip
      t.references :country, foreign_key: true
      t.string :phone
      t.string :address_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
