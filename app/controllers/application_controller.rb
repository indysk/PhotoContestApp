class ApplicationController < ActionController::Base
  include ApplicationHelper
  add_flash_types :success, :danger
  before_action :store_current_location, unless: :devise_controller?

  def check_logged_in
    unless signed_in?
      flash = 'ログインしてください'
      redirect_to user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || mypage_root_path
  end

  private
    def store_current_location
      store_location_for(:user, request.url)
    end
end
