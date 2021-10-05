class Vote < ApplicationRecord
  belongs_to :contest
  belongs_to :photo
  belongs_to :user

  def self.create_votes(para, contest, user)
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
      return false
    end
    return true
  end




end
