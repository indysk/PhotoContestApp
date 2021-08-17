class ContestsController < ApplicationController
  # before_action :check_logged_in, only: [:create, :update, :show, :destory]

  def index
    @contests = Contest.includes(:user).paginate(page: params[:page])
  end

  def show
    @contest = Contest.find_by(id: params[:id])
    redirect_to root_path unless @contest
  end

  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new(contest_params)
    user = current_user
    @contest.user_id = user ? user.id : 1
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
