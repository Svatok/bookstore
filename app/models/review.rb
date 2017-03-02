class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  scope :approved, -> { where("status = 'approved'").order(created_at: :desc) }
end
