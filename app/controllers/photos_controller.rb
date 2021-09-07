class PhotosController < ApplicationController
  before_action :check_correct_user_for_photo, only: [:edit, :update, :destory]

  def index
    @contest = Contest.find_by(id: params[:contest_id])
    render :new unless @contest
    @photos = @contest.photos
    @vote = Vote.new
  end

  def show
    @photo = Photo.find_by(id: params[:id])
    redirect_to :back unless @photo
  end

  def new
    @photo = Photo.new
  end

  def create
    @contest = Contest.find_by(id: params[:contest_id])
    render :new unless @contest
    @photo = @contest.photos.build(photo_params)
    render :new unless @photo

    if @photo.save
      redirect_to @contest
    else
      render :new
    end
  end

  def edit
    @photo = Photo.find_by(id: params[:id])
    redirect_to photos_path unless @photo
  end

  def update
    @photo = Photo.find_by(id: params[:id])
    if @photo && @photo.update(photo_params)
      redirect_to contest_path(@photo.contest)
    else
      flash[:danger] = '作品の編集に失敗しました'
      render :edit
    end
  end

  def destroy
    @photo = Photo.find_by(id: params[:id])
    if @photo && @photo.destroy
      flash[:success] = '写真の削除に成功しました'
      redirect_to path_for_redirect_from_photo_delete
    else
      flash[:danger] = 'コンテストが削除できませんでした'
      redirect_to path_for_photo(@photo)
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
