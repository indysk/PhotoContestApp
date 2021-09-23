module ApplicationHelper
  include ContestsHelper
  include PhotosHelper
  include UrlsHelper
  include VotesHelper

  def full_title(page_title = '')
    base_title = "Photo Contest"
    page_title.present? ? page_title + " | " + base_title : base_title
  end

  def correct_user?(user)
    user == current_user
  end

  def print_default_img
    'cat_S.jpg'
  end

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

  def print_datetime_with_wday(date)
    time = Time.parse(date.to_s)
    time.strftime("%Y/%m/%d(#{%w(日 月 火 水 木 金 土)[time.wday]}) %H:%M")
  end

  def print_date_with_wday(date)
    time = Time.parse(date.to_s)
    time.strftime("%Y/%m/%d(#{%w(日 月 火 水 木 金 土)[time.wday]})")
  end

  def print_date_for_form(date)
    date.strftime("%Y-%m-%d")
  end

  def print_time_for_form(date)
    date.strftime("%H:%M")
  end

  def print_datetime_from_string(date, time)
    Time.zone.parse("#{date} #{time}")
  end

end
