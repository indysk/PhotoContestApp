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

  def self.select_options
    options = {
      visible_range_entry:           [['一般に公開', 0], ['URLで限定公開', 1]],
      visible_range_vote:            [['一般に公開', 0], ['URLで限定公開', 1]],
      visible_range_show:            [['一般に公開', 0], ['URLで限定公開', 1]],
      visible_range_result:          [['一般に公開', 0], ['URLで限定公開', 1]],
      visible_setting_for_user_name: [['投票結果でのみ公開', 0], ['作品一覧と投票結果で公開', 1], ['公開しない', 2]]
    }
  end

  def self.form_options
    select_options = Contest.select_options
    now = Date.today.year
    options = [{entry_period: { label:  '作品の募集期間',
                                start: {obj:              'entry_start_at',
                                        label:            '作品の募集開始日時',
                                        default_datetime: now },
                                end:   {obj:              'entry_end_at',
                                        label:            '作品の募集終了日時',
                                        default_datetime: now }},
                vote_period:  { label:  '投票の募集期間',
                                start: {obj:              'vote_start_at',
                                        label:            '投票の募集開始日時',
                                        default_datetime: now },
                                end:   {obj:              'vote_end_at',
                                        label:            '投票の募集終了日時',
                                        default_datetime: now }}},

              { visible_range_entry:  { options:  select_options[:visible_range_entry],
                                        label:    '応募ページの公開範囲',
                                        selected: 0},
                visible_range_vote:   { options:  select_options[:visible_range_vote],
                                        label:    '投票ページの公開範囲',
                                        selected: 0},
                visible_range_show:   { options:  select_options[:visible_range_show],
                                        label:    '作品一覧の公開範囲',
                                        selected: 0},
                visible_range_result: { options:  select_options[:visible_range_result],
                                        label:    '投票結果の公開範囲',
                                        selected: 0 }},

              { visible_setting_for_user_name: {options: select_options[:visible_setting_for_user_name],
                                                label:    '作品の応募者名の公開範囲',
                                                selected: 0 }}]
  end

  def is_in_period_voting?
    return false if self.vote_start_at.nil?
    now = Time.current
    return self.vote_start_at <= now && now < self.vote_end_at ? true : false
  end

  def is_in_period_entry?
    return false if self.entry_start_at.nil?
    now = Time.current
    return self.entry_start_at <= now && now < self.entry_end_at ? true : false
  end

  def is_after_period_voting?
    return false if self.vote_start_at.nil?
    return self.vote_end_at <= Time.current ? true : false
  end

end
