class PhotosController < ApplicationController
  def index
    if (@user = current_user)
      @photos = Photo.find_by(user: @user).paginate(page: params[:page])
    else
      flash[:error] = "ゲストユーザの写真一覧は利用できません"
      redirect_to root_path
    end
  end

  def show
    @photo = Photo.find_by(id: params[:id])
    redirect_to photos_path unless @photo
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(contest_params)
    user = current_user
    @photo.user_id = user ? user.id : 1
    if @contest.save
      redirect_to root_path
    else
      render :new
    end
  end


  def edit
    @photo = Photo.find_by(id: params[:id])
    redirect_to photos_path unless @photo
  end
end
