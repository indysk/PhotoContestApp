class ApplicationController < ActionController::Base
  include ApplicationHelper
  add_flash_types :success, :danger

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

  def  check_already_voted(contest_id = nil, user_id = nil)
    contes_id ||= find_by(id: params[:contest_id]) || find_by(id: params[:id])
    unless vote ||= Vote.find_by(user: user_id || current_user.id, contest_id: contest_id)
      flash[:danger] = "すでに投票済みです"
      redirect_to Contest.find(params[:contest_id])
    end
  end

  def check_logged_in
    unless signed_in?
      flash = 'ログインしてください'
      redirect_to user_session_path
    end
  end
end
