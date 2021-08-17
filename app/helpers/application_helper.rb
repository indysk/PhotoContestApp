module ApplicationHelper
  include ContestsHelper

  def current_user_or_guest
    user = User.find(1) unless (user = current_user)
    return user
  end

end
