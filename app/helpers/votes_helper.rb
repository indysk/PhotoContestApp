module VotesHelper
  def url_for_votes_form(contest)
    contest_votes_path(@contest) if @contest.visible_range_vote == 0
    contest_votes_path(@contest.limited_url_vote) if @contest.visible_range_vote == 1
  end
end
