class ReviewDecorator < Draper::Decorator
  delegate_all

  def date_of_create
    object.created_at.strftime("%d/%m/%y")
  end

  def verification
    return ' ' unless object.user_id.present?
    'Verified Reviewer'
  end

end
