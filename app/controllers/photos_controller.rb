class PhotosController < ApplicationController
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


  private
    def photo_params
      params.require(:photo).permit(:name, :image).merge(user_id: current_user_or_guest.id)
    end
end
