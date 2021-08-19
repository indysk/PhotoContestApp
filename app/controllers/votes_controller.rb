class VotesController < ApplicationController
  def show
    contest = Contest.find_by(id: params[:contest_id])
    redirect_to root_path unless contest
    @result = contest.votes.group(:photo_id).count
  end

  def new
  end

  def create
    @contest = Contest.find_by(id: params[:contest_id])
    render :new unless @contest

    @vote = @contest.votes.build(user_id: current_user_or_guest.id)
    render :new unless @vote

    votes = []
    params[:vote][:photo_id].each do |photo_id|
      @vote_dup = @vote.dup
      @vote_dup.photo_id = photo_id
      votes << @vote_dup.photo_id unless @vote_dup.save
    end

    if params[:vote][:photo_id].count == votes.count
      flash[:success] = "投票を完了しました"
      redirect_to @contest
    else
      votes.each {|vote| Vote.find(vote).destroy}
      flash[:success] = "投票に失敗しました"
      redirect_to @contest
    end
  end

  private
    def vote_params
      params.require(:vote).permit(photo_id: [])
    end
end
