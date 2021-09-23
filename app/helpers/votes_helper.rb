module VotesHelper
  def url_for_votes_form(contest)
    contest_votes_path(contest.limited_url_vote) if contest.visible_range_vote.to_i == 1
    contest_votes_path(contest.id) if contest.visible_range_vote.to_i == 0
  end
end
