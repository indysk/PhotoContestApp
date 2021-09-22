class AdminController < ApplicationController
  before_action :check_logged_in, only: [:photos, :votes]
  before_action :check_correct_user_for_contest, only: [:photos, :votes]

  def index
    @contest ||= Contest.find_by(id: params[:contest_id])
    @photos ||= @contest.photos
    # @votes ||= @contest.votes if @contest.is_in_period_voting?
  end
end
