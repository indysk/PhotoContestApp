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

  def self.model_labels
    options = {
      name: 'コンテスト名',
      description: 'コンテストの説明',
      entry_period: '作品の募集期間',
      entry_start_at: '作品の募集開始日時',
      entry_end_at: '作品の募集終了日時',
      vote_period: '投票の募集期間',
      vote_start_at: '投票の募集開始日時',
      vote_end_at: '投票の募集終了日時',
      visible_range_entry: '応募ページの公開範囲',
      visible_range_vote: '投票ページの公開範囲',
      visible_range_show: '作品一覧の公開範囲',
      visible_range_result: '投票結果の公開範囲',
      visible_setting_for_user_name: '作品の応募者名の公開範囲'
    }
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
    contest_labels = Contest.model_labels
    select_options = Contest.select_options
    now = Date.today.year
    options = [{entry_period: { label:  contest_labels[:entry_period],
                                start: {obj:              'entry_start_at',
                                        label:            contest_labels[:entry_start_at],
                                        default_datetime: now },
                                end:   {obj:              'entry_end_at',
                                        label:            contest_labels[:entry_end_at],
                                        default_datetime: now }},
                vote_period:  { label:  contest_labels[:vote_period],
                                start: {obj:              'vote_start_at',
                                        label:            contest_labels[:vote_start_at],
                                        default_datetime: now },
                                end:   {obj:              'vote_end_at',
                                        label:            contest_labels[:vote_end_at],
                                        default_datetime: now }}},

              { visible_range_entry:  { options:  select_options[:visible_range_entry],
                                        label:    contest_labels[:visible_range_entry],
                                        selected: 0},
                visible_range_vote:   { options:  select_options[:visible_range_vote],
                                        label:    contest_labels[:visible_range_vote],
                                        selected: 0},
                visible_range_show:   { options:  select_options[:visible_range_show],
                                        label:    contest_labels[:visible_range_show],
                                        selected: 0},
                visible_range_result: { options:  select_options[:visible_range_result],
                                        label:    contest_labels[:visible_range_result],
                                        selected: 0 }},

              { visible_setting_for_user_name: {options:  select_options[:visible_setting_for_user_name],
                                                label:    contest_labels[:visible_setting_for_user_name],
                                                selected: 0 }}]
  end

  def excerpt_description(i = 50)
    description = self.description
    description.length > i ? description[0..i-1] + '...' : description
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
