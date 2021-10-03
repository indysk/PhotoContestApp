class Vote < ApplicationRecord
  belongs_to :contest
  belongs_to :photo
  belongs_to :user

  def create_votes(para, contest, user)
    vote = contest.votes.build(user: user)
    votes = []
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
    unless flag
      votes.each {|vote| Vote.find(vote).destroy}
      redirect_back fallback_location: root_path, danger: "投票に失敗しました" and return
    end
  end




end
