module ApplicationHelper
  include ContestsHelper
  include PhotosHelper

  def current_user_or_guest
    unless (user = current_user)
      user = User.find(Rails.application.credentials.guest[:id])
    end
    return user
  end
end
