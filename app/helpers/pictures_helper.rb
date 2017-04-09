module PicturesHelper

  def avatar_tag(user_id, user_name, style)
    capture_haml do
      if user_avatar(user_id).present?
        haml_tag('img.' + style, src: user_avatar(user_id).first.image_path)
      else
        haml_tag('span.' + style + '.logo-empty', user_name.first)
      end
    end
  end

  def user_avatar(user_id)
    user = User.find_by_id(user_id)
    user.try(:avatar) if user.present?
  end
end
