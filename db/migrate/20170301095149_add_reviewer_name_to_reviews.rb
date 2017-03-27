class AddReviewerNameToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :reviewer_name, :string
  end
end
