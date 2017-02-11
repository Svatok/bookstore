class CreateCharacteristics < ActiveRecord::Migration[5.0]
  def change
    create_table :characteristics do |t|
      t.string :characteristic_name

      t.timestamps
    end
  end
end
