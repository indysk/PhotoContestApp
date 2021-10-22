class ContestsController < ApplicationController
  before_action :check_logged_in, except: [:index, :show]
  before_action :check_correct_user, only: [:edit, :update, :destory]

  def index
    @contests = Contest.public_all.order('contests.created_at DESC').includes(:user).page(params[:page]).per(10)
    @contests_submited = Contest.joins(:photos).where('photos.user_id = ?', current_user.id).order('photos.created_at DESC').page(params[:page]).per(10).select('contests.id, contests.name, contests.vote_end_at') if signed_in?
    @submited_photos = Photo.where(user: current_user).order('created_at DESC').limit(5).select('id, name, contest_id') if signed_in?
  end

  def show
    if @contest = Contest.find_by(id: params[:id])
      @user_photos = @contest.photos.where(user: current_user).order('created_at ASC')
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
    @contest.create_limited_url
    if @contest.save
      flash[:success] = 'コンテストを作成しました'
      redirect_to @contest
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
      redirect_to contest_path(@contest), success: 'コンテストを変更しました'
    else
      render :edit, danger: 'コンテストの変更に失敗しました'
    end
  end

  def destroy
    @contest ||= Contest.find_by(id: params[:id])
    if @contest && @contest.destroy
      flash[:success] = 'コンテストを削除しました'
      redirect_to root_path
    else
      flash[:danger] = 'コンテストが削除できませんでした'
      redirect_to contest_path(params[:id])
    end
  end

  def index_ajax
    if params[:target] == 'contests'
      @contests = Contest.public_all.order('contests.created_at DESC').includes(:user).page(params[:page]).per(10)
      @target = 'contests'
    elsif params[:target] == 'contests_submited'
      @contests = Contest.joins(:photos).where('photos.user_id = ?', current_user.id).order('photos.created_at DESC').page(params[:page]).per(10).select('contests.id, contests.name, contests.vote_end_at') if signed_in?
      @target = 'contests_submited'
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
        :voting_points, :num_of_submit_limit, :num_of_views_in_result,
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

    def check_correct_user
      @contest ||= Contest.find_by(id: params[:contest_id] || params[:id])
      redirect_back fallback_location: root_path, danger: 'コンテストの取得に失敗しました' and return unless @contest
      @user = @contest.user
      redirect_back fallback_location: root_path, danger: '現在のユーザはこのコンテストの作成者ではありません' and return unless correct_user?(@user)
    end
end
