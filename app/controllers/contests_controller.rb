class ContestsController < ApplicationController
  # before_action :check_logged_in, only: [:create, :update, :show, :destory]

  def index
    @contests = Contest.includes(:user).paginate(page: params[:page])
  end

  def show
    if (@contest = Contest.find_by(id: params[:id]))
      @photos = @contest.photos.includes(:user).paginate(page: params[:page])
    else
      redirect_to root_path
    end
    @vote = Vote.new
  end

  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new(contest_params)
    @contest.user_id = current_user_or_guest.id
    if @contest.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  private
    def contest_params
      params.require(:contest).permit(:name)
    end
end
