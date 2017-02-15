class CreateAuthorsProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :authors_products, id: false do |t|
      t.belongs_to :author, index: true
      t.belongs_to :product, index: true
    end
  end
end
