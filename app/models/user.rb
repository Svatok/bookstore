class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :identities, dependent: :destroy

  attr_accessor :skip_password_validation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :set_default_role
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update
  validates :email, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX },
                    length: { maximum: 63 },
                    presence: true
  validates :password, length: { minimum: 8 },
                       format: { with: /\A(?=.*\d)(?=.*[A-Z])(?=.*[a-z])\w+{,8}\z/ },
                       presence: true, if: :password_required?
  # devise :omniauthable, :omniauth_providers => [:facebook]

  def role?(r)
    role.include? r.to_s
  end

  def password_required?
    return false if skip_password_validation
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def update
    # required for settings form to submit when password is left blank
    if params[:user][:current_password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    binding.pry
    if user.nil?
      email = auth.info.email
      user = User.where(:email => email).first if email.present?
      binding.pry
      if user.nil?
        user = User.new(
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        binding.pry
        user.skip_confirmation!
        user.save!
        user.pictures.create(remote_image_path_url: auth.info.image.gsub('http://', 'https://')) if auth.info.image.present?
        user.addresses.create(user.address_params(auth.info.name)) if auth.info.name.present?
binding.pry
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def address_params(name)
    name = name.split(' ')
    first_name = name.first
    last_name = name.last.present? ? name.last : ''
    {first_name: first_name, last_name: last_name, address_type: 'billing'}
  end
  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #     user.skip_confirmation!
  #     user.save
  #     user.pictures.create(remote_image_path_url: auth.info.image.gsub('http://', 'https://'))
  #     name = auth.info.name.split(' ')
  #     user.addresses.create(first_name: name.first, last_name: name.last, address_type: 'billing')
  #   end
  # end
  #
  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end

  private

  def set_default_role
    self.role ||= 'none'
  end

end
