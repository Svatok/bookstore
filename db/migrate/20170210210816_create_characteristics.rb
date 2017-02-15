class CreateCharacteristics < ActiveRecord::Migration[5.0]
  def change
    create_table :characteristics do |t|
      t.references :product, foreign_key: true
      t.references :property, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
