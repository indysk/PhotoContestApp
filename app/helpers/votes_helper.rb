module VotesHelper
  def url_for_votes_form(contest)
    if contest.visible_range_vote.to_s == '1'
      contest_votes_path(contest.limited_url_vote)
    else
      contest_votes_path(contest.id)
    end
  end
end
