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
    @select_options = Contest.form_select_options
  end

  def create
    @contest = Contest.new(contest_params)
    @contest.user_id = current_user_or_guest.id
    if @contest.save
      redirect_to root_path
    else
      @select_options = Contest.form_select_options
      render :new
    end
  end

  def edit
  end

  def destroy
    @contest = Contest.find_by(id: params[:id])
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
