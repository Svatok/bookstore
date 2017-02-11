class CreateProductProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :product_properties do |t|
      t.references :product, foreign_key: true
      t.references :characteristic, foreign_key: true
      t.string :property_value

      t.timestamps
    end
  end
end
