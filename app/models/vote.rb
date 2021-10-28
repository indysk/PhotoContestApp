class Vote < ApplicationRecord
  belongs_to :contest
  belongs_to :photo
  belongs_to :user

  def self.create_votes(para, contest, user)
    # コンテストとユーザに値を入れたレコードをbuildする
    vote = contest.votes.build(user: user)

    # レコードを複製し、paramsで受け取った投票データの作品idとポイントを保存する
    votes = []
    flag = true
    para[:vote].each do |photo_id, point|
      next if point.blank? || point == '0'
      vote_dup = vote.dup
      vote_dup.photo_id = photo_id
      vote_dup.point = point.to_i
      # 投票失敗時の処理に備えて保存できたレコードを記録する
      if vote_dup.save
        votes << vote_dup.id
      else
        flag = false
        break
      end
    end
    # 投票に失敗したらそれ以前に保存したデータを削除
    unless flag
      votes.each {|vote| Vote.find(vote).destroy}
      return false
    end
    return true
  end




end
