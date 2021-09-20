class PhotosController < ApplicationController
  before_action :check_logged_in, except: [:index, :show]
  before_action :check_correct_user_for_photo, only: [:edit, :update, :destory]

  def index
    @contest = Contest.find_by(id: params[:contest_id])
    render :new unless @contest
    @photos = @contest.order('id ASC')
    @vote = Vote.new
  end

  def show
    @photo = Photo.find_by(id: params[:id])
    redirect_back fallback_location: root_path, danger: '作品が見つかりませんでした。' unless @photo
  end

  def new
    @photo = Photo.new
    @contest = Contest.find_contest_entry(params[:contest_id])

    redirect_to root_path, danger: 'コンテストが見つかりませんでした。' unless @contest
  end

  def create
    @contest = Contest.find_by(id: params[:contest_id])
    unless @contest
      flash.now[:danger] = 'コンテストが見つかりませんでした'
      render :new and return
    end
    @photo = @contest.photos.build(photo_params)

    if @photo && @photo.save
      redirect_to @contest, success: '作品を提出しました'
    else
      render :new and return
    end
  end

  def edit
    @contest = Contest.find_by(id: params[:contest_id])
    @photo = Photo.find_by(id: params[:id])

    unless @contest
      flash[:danger] = 'コンテストが見つかりませんでした'
      redirect_back fallback_location: root_path and return
    end

    unless @photo
      flash[:danger] = '作品が見つかりませんでした'
      redirect_back fallback_location: root_path and return
    end
  end

  def update
    @photo = Photo.find_by(id: params[:id])
    if @photo && @photo.update(photo_params)
      redirect_to contest_path(@photo.contest) and return
    else
      flash[:danger] = '作品の編集に失敗しました'
      render :edit and return
    end
  end

  def destroy
    @photo = Photo.find_by(id: params[:id])
    if @photo && @photo.destroy
      flash[:success] = '写真の削除に成功しました'
      redirect_to path_for_redirect_from_photo_delete and return
    else
      flash[:danger] = 'コンテストが削除できませんでした'
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
