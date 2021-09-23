class PhotosController < ApplicationController
  before_action :check_logged_in, except: [:index, :show]
  before_action :check_correct_user_for_photo, only: [:edit, :update, :destory]

  def index
    @contest = Contest.find_contest_vote_or_entry(params[:contest_id])
    redirect_back fallback_location: root_path, danger: 'コンテストの取得に失敗しました' and return unless @contest
    @vote = Vote.new if @contest.is_in_period_voting?
    @photos = @contest.photos.order('id ASC')
  end

  def show
    @photo = Photo.find_by(id: params[:id])
    redirect_back fallback_location: root_path, danger: '作品の取得に失敗しました' and return unless @photo
  end

  def new
    @photo = Photo.new
    @contest = Contest.find_contest_entry(params[:contest_id])

    redirect_to root_path, danger: 'コンテストの取得に失敗しました' and return unless @contest
  end

  def create
    @contest = Contest.find_contest_entry(params[:contest_id])
    unless @contest
      flash[:danger] = 'コンテストの取得に失敗しました'
      redirect_to :new and return
    end
    @photo = @contest.photos.build(photo_params)

    if @photo && @photo.save
      redirect_to @contest, success: '作品を提出しました'
    else
      flash.now[:danger] = '作品の提出に失敗しました'
      render :new and return
    end
  end

  def edit
    @contest = Contest.find_by(id: params[:contest_id])
    @photo = Photo.find_by(id: params[:id])

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
    redirect_to root_path, danger: '作品の取得に失敗しました' and return unless @photo = Photo.find_by(id: params[:id])
    @contest = @photo.contest
    if @photo.update(photo_params)
      redirect_to contest_path(@contest) and return
    else
      flash.now[:danger] = '作品の編集に失敗しました'
      render :edit and return
    end
  end

  def destroy
    @photo = Photo.find_by(id: params[:id])
    if @photo && @photo.destroy
      flash[:success] = '写真の削除に成功しました'
      redirect_to path_for_redirect_from_photo_delete and return
    else
      flash[:danger] = 'コンテストの削除に失敗しました'
      redirect_to path_for_photo(@photo) and return
    end
  end

  private
    def photo_params
      params.require(:photo).permit(
        :name, :description,
        :photographer, :camera, :lens,
        :iso, :aperture, :shutter_speed, :image
        ).merge(user: current_user)
    end
end
