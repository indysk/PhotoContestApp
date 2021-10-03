class AdminController < ApplicationController
  before_action :check_logged_in, only: [:photos, :votes]
  before_action :check_correct_user_for_contest, only: [:photos, :votes]

  def index
    @contest ||= Contest.find_by(id: params[:contest_id])
    @photos ||= @contest.photos
    # @votes ||= @contest.votes if @contest.is_in_period_voting?
  end

  def photo_delete
    @photo ||= Photo.find_by(id: params[:id])
    redirect_to root_path, danger: '作品の取得に失敗しました' and return unless @photo

    if @photo.destroy
      flash[:success] = '作品の削除に成功しました'
      redirect_to path_for_redirect_from_photo_delete and return
    else
      flash[:danger] = '作品の削除に失敗しました'
      redirect_to path_for_photo(@photo) and return
    end
  end
end
