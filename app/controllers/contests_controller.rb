class ContestsController < ApplicationController
  before_action :check_logged_in, except: [:index, :show]
  before_action :check_correct_user_for_contest, only: [:edit, :update, :destory]

  def index
    @contests = Contest.includes(:user).paginate(page: params[:page])
    @submited_contests = Contest.joins(:photos).where('photos.user_id = ?', current_user.id).order('photos.created_at DESC').limit(5).select('contests.id, contests.name, contests.vote_end_at') if signed_in?
  end

  def show
    if (@contest = Contest.find_by(id: params[:id]))
      @photos = @contest.photos.includes(:user).paginate(page: params[:page]).order('id ASC')
      @options ||= Contest.select_options
      @urls = Url.new().urls_for_view(@contest)
    else
      flash[:danger] = 'コンテストは存在しません'
      redirect_to root_path
    end
  end

  def new
    @contest = Contest.new
    @contest.initialize_for_form
  end

  def create
    @contest ||= Contest.new(contest_params)
    @contest.user_id = current_user.id
    if @contest.save && (@contest.create_limited_url(contest_params_limited_url))
      flash[:success] = '正常にコンテストが作成されました'
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
      get = params.require(:contest).permit(
        :name,
        :description,
        :entry_start_at_date, :entry_start_at_time, :entry_end_at_date, :entry_end_at_time,
        :vote_start_at_date, :vote_start_at_time, :vote_end_at_date, :vote_end_at_time,
        :visible_range_entry, :visible_range_vote, :visible_range_show, :visible_range_result,
        :voting_points,
        :num_of_views_in_result,
        :visible_setting_for_user_name
      )

      tmp = {
        entry_start_at: print_datetime_from_string(get[:entry_start_at_date], get[:entry_start_at_time]),
        entry_end_at:   print_datetime_from_string(get[:entry_end_at_date], get[:entry_end_at_time]),
        vote_start_at:  print_datetime_from_string(get[:vote_start_at_date], get[:vote_start_at_time]),
        vote_end_at:    print_datetime_from_string(get[:vote_end_at_date], get[:vote_end_at_time])
      }

      delete_list = %w(entry_start_at_date entry_start_at_time entry_end_at_date entry_end_at_time vote_start_at_date vote_start_at_time vote_end_at_date vote_end_at_time)
      delete_list.each do |value|
        get.delete(value)
      end

      get.merge(tmp)
    end

    def check_already_voted
      super if Contest.find(params[:contest_id]).is_in_period_voting?
    end
end
