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
    @debug1 = params[:photo]
    @photo = @contest.photos.build(photo_params)
    render :new unless @photo
    @debug2 = photo_params
    @photo.user_id = current_user_or_guest.id
    if @photo.save
      @debug3 = @photo.image
      @debug5 = @photo
      @photo2 = Photo.find_by(user: current_user_or_guest, contest: @contest, name: params[:photo][:name], created_at: @photo.created_at)
      @debug4 = @photo2.image
      @debug6 = @photo2
      # redirect_to @contest
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
      params.require(:photo).permit(:name, :image)
    end
end
