class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  scope :approved, -> { where("status = 'approved'").order(created_at: :desc) }
  scope :unprocessed, -> { where("reviews.status IS NULL").order(created_at: :desc) }
  scope :processed, -> { where("reviews.status IS NOT NULL").order(created_at: :desc) }

end
