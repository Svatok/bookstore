class User < ApplicationRecord
  has_many :addresses, as: :addressable
  has_many :reviews
  has_many :orders
  has_many :pictures, as: :imageable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :set_default_role
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  def role?(r)
    role.include? r.to_s
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
      user.save
      user.pictures.create(remote_image_path_url: auth.info.image.gsub('http://', 'https://'))
      name = auth.info.name.split(' ')
      user.addresses.create(first_name: name.first, last_name: name.last, address_type: 'billing')
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private

  def set_default_role
    self.role ||= 'none'
  end

end
