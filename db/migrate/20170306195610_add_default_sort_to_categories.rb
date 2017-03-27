class AddDefaultSortToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :default_sort, :boolean, default: false
  end
end
