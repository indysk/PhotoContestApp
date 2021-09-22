class VotesController < ApplicationController
  before_action :check_logged_in, except: [:index]
  before_action :check_already_voted, only: [:create]

  def index
    @contest = Contest.find_contest_result(params[:contest_id])
    redirect_back fallback_location: root_path, danger: 'コンテストが見つかりませんでした。' and return unless @contest
    @result = @contest.vote_result
  end

  def create
    @contest ||= Contest.find_contest_vote(params[:contest_id])
    unless @contest
      flash.now[:danger] = 'コンテストの取得に失敗しました'
      render 'photos/index' and return
    end

    @vote = @contest.votes.build(user: current_user)
    render 'photos/index' and return unless @vote

    votes = []
    para = vote_params
    flag = true
    para[:vote].each do |photo_id, point|
      next if point.blank? || point == '0'
      vote_dup = @vote.dup
      vote_dup.photo_id = photo_id
      vote_dup.point = point.to_i
      if vote_dup.save
        votes << vote_dup.id
      else
        flag = false
        break
      end
    end

    if flag
      flash[:success] = "投票を完了しました"
      redirect_to @contest and return
    else
      votes.each do |vote|
        Vote.find(vote).destroy
      end
      redirect_back fallback_location: root_path, danger: "投票に失敗しました" and return
    end
  end

  private
    def vote_params
      params.require(:vote).permit(vote: {})
    end
end
