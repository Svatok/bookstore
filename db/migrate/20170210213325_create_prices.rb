class CreatePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :prices do |t|
      t.float :value
      t.date :date_start
      t.references :priceable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
