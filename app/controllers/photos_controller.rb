class PhotosController < ApplicationController
  before_action :check_logged_in, except: [:index, :show]
  before_action :check_correct_user, only: [:edit, :update, :destory]
  before_action :check_able_to_submit, only: [:new, :create]
  before_action :check_able_to_edit, only: [:edit, :update, :destroy]

  def index
    @contest ||= Contest.find_contest_show(params[:contest_id])
    redirect_back fallback_location: root_path, danger: 'コンテストの取得に失敗しました' and return unless @contest
    redirect_back fallback_location: @contest, danger: '閲覧可能期間外です' and return unless @contest.is_in_period_show?
    if @contest.visible_setting_for_user_name.to_s == '1'
      @photos = @contest.photos.order('id ASC').includes(:user)
    else
      @photos = @contest.photos.order('id ASC')
    end
  end

  def show
    @photo = Photo.find_by(id: params[:id]).eager_load(:user, :contest)
    redirect_back fallback_location: root_path, danger: '作品の取得に失敗しました' and return unless @photo
  end

  def new
    @contest ||= Contest.find_contest_entry(params[:contest_id])
    @photo = Photo.new
  end

  def create
    @contest ||= Contest.find_contest_entry(params[:contest_id])
    @photo = @contest.photos.build(photo_params)
    if @photo && @photo.save
      redirect_to @contest, success: '作品を提出しました'
    else
      flash.now[:danger] = '作品の提出に失敗しました'
      render :new and return
    end
  end

  def edit
    @contest ||= Contest.find_by(id: params[:contest_id])
    @photo ||= Photo.find_by(id: params[:id])

    unless @contest
      flash[:danger] = 'コンテストの取得に失敗しました'
      redirect_back fallback_location: root_path and return
    end

    unless @photo
      flash[:danger] = '作品の取得に失敗しました'
      redirect_back fallback_location: root_path and return
    end
  end

  def update
    @photo ||= Photo.find_by(id: params[:id])
    redirect_to root_path, danger: '作品の取得に失敗しました' and return unless @photo
    if @photo.update(photo_params)
      redirect_to contest_photo_path(@photo.contest_id, @photo), success: '作品の更新に成功しました' and return
    else
      flash.now[:danger] = '作品の編集に失敗しました'
      render :edit and return
    end
  end

  def destroy
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

  private
    def photo_params
      params.require(:photo).permit(
        :name, :description,
        :camera, :lens,
        :iso, :aperture, :shutter_speed, :image
        ).merge(user: current_user)
    end

    def check_able_to_submit
      @contest ||= Contest.find_contest_entry(params[:contest_id])
      redirect_back fallback_location: root_path, danger: 'コンテストの取得に失敗しました' and return unless @contest
      redirect_back fallback_location: @contest, danger: '作品を提出済みです' and return unless @contest.is_submitted_limit_times?(current_user, self.num_of_submit_limit)
      redirect_back fallback_location: @contest, danger: '作品募集期間外です' and return unless @contest.is_in_period_entry?
    end

    def check_correct_user
      @photo ||= Photo.find_by(id: params[:id])
      redirect_back fallback_location: root_path, danger: '作品の取得に失敗しました' and return unless @photo
      @user = @photo.user
      redirect_back fallback_location: root_path, danger: '現在のユーザはこの作品の作成者ではありません' and return unless correct_user?(@user)
    end

    def check_able_to_edit
      @contest ||= Contest.find_contest_entry(params[:contest_id])
      @contest ||= Photo.find_by(id: params[:id]).contest unless @contest
      redirect_back fallback_location: root_path, danger: 'コンテストの取得に失敗しました' and return unless @contest
      redirect_back fallback_location: @contest, danger: '投票開始時間を過ぎているので作品の編集はできません' and return if @contest.is_after_period_voting?
    end
end
