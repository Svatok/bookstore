class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.references :product, foreign_key: true
      t.integer :value
      t.date :date_start

      t.timestamps
    end
  end
end
