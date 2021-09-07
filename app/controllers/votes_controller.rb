class VotesController < ApplicationController
  def index
    @contest = Contest.find_by(id: params[:contest_id])
    redirect_to root_path unless @contest
    @result = @contest.vote_result
  end

  def create
    contest = Contest.find_by(id: params[:contest_id])
    render :new unless contest

    vote = contest.votes.build(user: current_user)
    render :new unless vote

    votes = []
    para = vote_params
    flag = true
    para[:vote].each do |photo_id, point|
      next if point.blank? || point == '0'
      vote_dup = vote.dup
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
      redirect_to contest
    else
      votes.each do |vote|
        Vote.find(vote).destroy
      end
      flash[:danger] = "投票に失敗しました"
      redirect_to contest
    end
  end

  private
    def vote_params
      params.require(:vote).permit(vote: {})
    end
end
