class ApplicationController < ActionController::Base
  include ApplicationHelper

  def check_correct_user
    if (@user ||= User.find_by(id: params[:user_id] || params[:id]))
      unless correct_user?(@user)
        flash[:danger] = 'ユーザが正しくありません'
        redirect_to root_path
      end
    else
      flash[:danger] = 'ユーザが見つかりませんでした'
      redirect_to root_path
    end
  end

  def check_correct_user_for_contest
    if (@contest ||= Contest.find_by(id: params[:contest_id] || params[:id]))
      @user = @contest.user
      check_correct_user
    else
      flash[:danger] = 'コンテストが見つかりませんでした'
      redirect_to(root_path)
    end
  end

  def check_correct_user_for_photo
    if (@photo ||= Photo.find_by(id: params[:id]))
      @user = @photo.user
      check_correct_user
    else
      flash[:danger] = '作品が見つかりませんでした'
      redirect_to(root_path)
    end
  end

end
