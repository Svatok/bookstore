module PicturesHelper

  def avatar_tag(user_id, user_name, style)
    capture_haml do
      return haml_tag('span.' + style + '.logo-empty', user_name.first) unless user_avatar(user_id).present?
      haml_tag('img.' + style, src: user_avatar(user_id).image_path)
    end
  end

  def user_avatar(user_id)
    user = User.find_by_id(user_id)
    return unless user.present?
    user.pictures.avatar.first
  end

end
