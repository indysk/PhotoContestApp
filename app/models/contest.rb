class Contest < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :votes, dependent: :destroy
  default_scope -> { order(created_at: :desc) }

  # #===nameカラム============================================================
  before_save { self.name = name.gsub(/\A[[:space:]]+|[[:space:]]\z/, "") }
  validates :name,  presence: true,
                    length: { maximum: 255, allow_blank: true }
  # #========================================================================

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

  def self.form_select_options
    options = [{entry_period: { label:  '作品の募集期間',
                                start: {obj:              'entry_start_at',
                                        label:            '作品の募集開始日時',
                                        default_datetime: Date.today.year },
                                end:   {obj:              'entry_end_at',
                                        label:            '作品の募集終了日時',
                                        default_datetime: Date.today.year }},
                vote_period:  { label:  '投票の募集期間',
                                start: {obj:              'vote_start_at',
                                        label:            '投票の募集開始日時',
                                        default_datetime: Date.today.year },
                                end:   {obj:              'vote_end_at',
                                        label:            '投票の募集終了日時',
                                        default_datetime: Date.today.year }}},

              { visible_range_entry:  { options:  [['一般に公開', 1], ['URLで限定公開', 2]],
                                        label:    '応募ページの公開範囲',
                                        selected: 1},
                visible_range_vote:   { options:  [['一般に公開', 1], ['URLで限定公開', 2]],
                                        label:    '投票ページの公開範囲',
                                        selected: 1},
                visible_range_show:   { options:  [['一般に公開', 1], ['URLで限定公開', 2]],
                                        label:    '作品一覧の公開範囲',
                                        selected: 1},
                visible_range_result: { options:  [['一般に公開', 1], ['URLで限定公開', 2]],
                                        label:    '投票結果の公開範囲',
                                        selected: 1 }},

              { visible_setting_for_user_name: {options: [['投票結果でのみ公開', 1],
                                                          ['作品一覧と投票結果で公開', 2],
                                                          ['公開しない', 3] ],
                                                label:    '作品の応募者名の公開範囲',
                                                selected: 1 }}]
  end
end
