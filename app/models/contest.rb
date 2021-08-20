class Contest < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :votes, dependent: :destroy
  default_scope -> { order(created_at: :desc) }

  def vote_result
    votes = self.votes.includes(:photo, :user)
    result = []
    votes.each do |vote|
      photo_id = vote.photo.id
      flag = false
      result.each_with_index do |item, i|
        if item[:photo_id] == photo_id
          result[i][:num] += 1
          flag = true
          break
        end
      end

      unless flag
        result << {photo_id: photo_id, photo: vote.photo, user: vote.user, num: 1}
      end
    end
    result.sort! do |a, b|
      [-a[:num], a[:photo_id]] <=> [-b[:num], b[:photo_id]]
    end
    return result
  end
end
