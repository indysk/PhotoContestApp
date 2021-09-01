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

  # def print_link_button(path = '', value = '', bool = true, tag_class = 'link_button')
  #   bool ? link_to(value, path, class: tag_class + '-true') : content_tag(:div, value, class: tag_class + '-false')
  # end

  def print_link_button(name = nil, options = nil, bool = true, html_options = nil, &block)
    options, bool, html_options, name = name, options, bool, block if block_given?
    options ||= {}

    html_options = convert_options_to_data_attributes(options, html_options)

    url = url_for(options)
    html_options["href"] ||= url
    html_class = html_options["class"]
    html_options["class"] += " #{html_class}-false" unless bool

    bool ? content_tag("a", name || url, html_options, &block) : content_tag(:div, name, html_options, &block)
  end

end
