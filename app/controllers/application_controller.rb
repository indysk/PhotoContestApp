class ApplicationController < ActionController::Base
  include ApplicationHelper
  add_flash_types :success, :danger

  def check_logged_in
    unless signed_in?
      flash = 'ログインしてください'
      redirect_to user_session_path
    end
  end
end
