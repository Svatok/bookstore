class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :identities, dependent: :destroy

  delegate :avatar, to: :pictures

  attr_accessor :skip_password_validation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :set_default_role
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update
  validates :email, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX },
                    length: { maximum: 63 },
                    presence: true
  validates :password, length: { minimum: 8 },
                       presence: true, if: :password_required?

  def role?(r)
    role.include? r.to_s
  end

  def password_required?
    return false if skip_password_validation
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email = auth.info.email
      user = User.find_by(email: email).try(:first) if email.present?
      user = create_new_user(email, auth) if user.nil?
    end
    set_identity(identity, user)
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  private

  def self.set_identity(identity, user)
    return if identity.user == user
    identity.user = user
    identity.save!
  end

  def self.create_new_user(email, auth)
    user = User.new(
      email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
      password: Devise.friendly_token[0,20]
    )
    user.skip_password_validation = true
    user.skip_confirmation!
    user.save!
    user.pictures.create(remote_image_path_url: auth.info.image.gsub('http://', 'https://')) if auth.info.image.present?
    user.addresses.create(address_params(auth.info.name)) if auth.info.name.present?
    user
  end

  def self.address_params(name)
    name = name.split(' ')
    first_name = name.first
    last_name = name.last.to_s
    { first_name: first_name, last_name: last_name, address_type: 'billing' }
  end

  def set_default_role
    self.role ||= 'none'
  end
end
