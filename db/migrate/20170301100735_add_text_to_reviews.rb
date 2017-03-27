class AddTextToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :review_text, :text
  end
end
