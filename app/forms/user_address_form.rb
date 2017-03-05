class UserAddressForm < Rectify::Form
  attribute :id, String
#  attribute :addressable_id, String
#  attribute :address_type, String
  attribute :first_name, String
  attribute :last_name,  String
  attribute :address,  String
  attribute :city,  String
  attribute :zip,  String
  attribute :country_id,  String
  attribute :phone,  String

  validates :first_name, :last_name, :presence => true
end
