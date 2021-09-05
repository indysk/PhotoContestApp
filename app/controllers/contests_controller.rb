class ContestsController < ApplicationController
  before_action :check_correct_user_for_contest, only: [:edit, :update, :destory]

  def index
    @contests = Contest.includes(:user).paginate(page: params[:page])
  end

  def show
    if (@contest = Contest.find_by(id: params[:id]))
      @photos = @contest.photos.includes(:user).paginate(page: params[:page])
      @options ||= Contest.select_options
    else
      redirect_to root_path
    end
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
    @contest ||= Contest.find_by(id: params[:id])
  end

  def update
    @contest ||= Contest.find_by(id: params[:id])
    if @contest && @contest.update(contest_params)
      redirect_to contest_path(@contest)
    else
      render :edit
    end
  end

  def destroy
    @contest ||= Contest.find_by(id: params[:id])
    if @contest && @contest.destroy
      flash[:success] = 'コンテストの削除に成功しました'
      redirect_to root_path
    else
      flash[:danger] = 'コンテストが削除できませんでした'
      redirect_to contest_path(params[:id])
    end
  end

  private
    def contest_params
      params.require(:contest).permit(:name,
                                      :description,
                                      :entry_start_at,
                                      :entry_end_at,
                                      :vote_start_at,
                                      :vote_end_at,
                                      :visible_range_entry,
                                      :visible_range_vote,
                                      :visible_range_show,
                                      :visible_range_result,
                                      :voting_points,
                                      :num_of_views_in_result,
                                      :visible_setting_for_user_name)
    end
  end
