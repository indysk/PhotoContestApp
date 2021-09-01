module ApplicationHelper
  include ContestsHelper
  include PhotosHelper

  def current_user_or_guest
    unless (user = current_user)
      user = User.find(Rails.application.credentials.guest[:id])
    end
    return user
  end

  def print_current_user_with_link
    user = current_user
    user_signed_in? ? link_to(user.name, user_path(user)) : 'ゲストモード'
  end

  def print_current_user
    user = current_user
    user_signed_in? ? user.name : 'ゲストモード'
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

  def correct_user?(user)
    user == current_user
  end

  def print_default_img
    'cat_S.jpg'
  end

  def print_link_button(path = '', value = '', bool = true, tag_class = 'link_button')
    bool ? link_to(value, path, class: tag_class + '-true') : content_tag(:div, value, class: tag_class + '-false')
  end

end
