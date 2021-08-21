module ApplicationHelper
  include ContestsHelper
  include PhotosHelper

  def current_user_or_guest
    unless (user = current_user)
      user = User.find(Rails.application.credentials.guest[:id])
    end
    return user
  end

  def print_contest_creator(contest)
    user = contest.user
    return link_to(user.name, user_path(user)) unless user.guest?
    return user.name
  end

  def print_photo_creator(photo)
    user = photo.user
    return link_to(user.name, user_path(user)) unless user.guest?
    return user.name
  end
end
