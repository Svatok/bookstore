class UserAddressForm < Rectify::Form
  attribute :id, String
  attribute :address_type, String
  attribute :first_name, String
  attribute :last_name, String
  attribute :address, String
  attribute :city, String
  attribute :zip, String
  attribute :country_id, String
  attribute :phone, String

  validates_presence_of :first_name, :last_name, :address_type, :address, :city, :zip, :country_id, :phone
  validates :first_name, format: { with: /[a-z]/i }, length: { maximum: 50 }
  validates :last_name, format: { with: /[a-z]/i }, length: { maximum: 50 }
  validates :address, format: { with: /[a-z0-9,\s-]/i }, length: { maximum: 50 }
  validates :city, format: { with: /[a-z]/i }, length: { maximum: 50 }
  validates :zip, format: { with: /[0-9-]/i }, length: { maximum: 10 }
  validates :phone, format: { with: /\A\+\d{9,15}\z/ }, length: { maximum: 15 }
  validate :check_phone_code

  def check_phone_code
    country = Country.find_by_id(country_id)
    return if phone =~ /\A\+#{country.phone_number}/
    errors.add(:phone, 'country code is invalid.')
  end

end
