class VotesController < ApplicationController
  before_action :check_logged_in, except: [:index]
  before_action :check_able_to_vote, only: [:new, :create]

  def index
    @contest ||= Contest.find_contest_result(params[:contest_id])
    redirect_back fallback_location: root_path, danger: 'コンテストの取得に失敗しました' and return unless @contest
    redirect_back fallback_location: @contest, danger: '結果公表期間外です' and return unless @contest.is_in_period_result?
    @result = @contest.vote_result
  end

  def new
    @contest ||= Contest.find_contest_vote(params[:contest_id])
    @vote = Vote.new
    @photos = @contest.photos.order('id ASC')
  end

  def create
    @contest ||= Contest.find_contest_vote(params[:contest_id])
    if Vote.create_votes(vote_params, @contest, current_user)
      redirect_to @contest, success: '投票に成功しました' and return
    else
      redirect_back fallback_location: root_path, danger: "投票に失敗しました" and return
    end
  end

  private
    def vote_params
      params.require(:vote).permit(vote: {})
    end

    def check_able_to_vote
      @contest ||= Contest.find_contest_vote(params[:contest_id] || params[:id])
      redirect_back fallback_location: root_path, danger: 'コンテストの取得に失敗しました' and return unless @contest
      redirect_back fallback_location: @contest, danger: '投票期間外です' and return unless @contest.is_in_period_voting?
      redirect_back fallback_location: @contest, danger: '投票済みです' and return if @contest.is_already_voted?(current_user)
    end
end
