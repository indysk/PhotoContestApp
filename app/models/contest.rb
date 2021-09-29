class Contest < ApplicationRecord
  class ShouldBeLaterThanValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if option[:or_equal] && !(option[:time] <= value)
        record.errors[attribute] << (options[:message] || "の時刻エラーです")
        return
      end
      if !(option[:time] < value)
        record.errors[attribute] << (options[:message] || "の時刻エラーです")
        return
      end
    end
  end
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :votes, dependent: :destroy

  scope :public_all, -> (time = Time.current){ where('( :time < `contests`.`entry_end_at` AND `contests`.`visible_range_entry` = 0 ) OR ( `contests`.`entry_end_at` <= :time AND :time < `contests`.`vote_end_at` AND `contests`.`visible_range_vote` = 0 ) OR ( `contests`.`vote_end_at` <= :time AND ( `contests`.`visible_range_show` = 0 OR `contests`.`visible_range_result` = 0 ) )', {time: time}) }
  scope :public_page, -> (page){ where(:"visible_range_#{page}" => 0)}
  scope :private_page, -> (page){ where(:"visible_range_#{page}" => 1)}


  scope :find_entry_by_id,  -> (contest_id){ where('(`contests`.`id` = :id AND `contests`.`visible_range_entry`  = 0) OR (`contests`.`limited_url_entry`  = :id AND `contests`.`visible_range_entry`  = 1)', {id: contest_id}).limit(1) }
  scope :find_vote_by_id,   -> (contest_id){ where('(`contests`.`id` = :id AND `contests`.`visible_range_vote`   = 0) OR (`contests`.`limited_url_vote`   = :id AND `contests`.`visible_range_vote`   = 1)', {id: contest_id}).limit(1) }
  scope :find_show_by_id,   -> (contest_id){ where('(`contests`.`id` = :id AND `contests`.`visible_range_show`   = 0) OR (`contests`.`limited_url_show`   = :id AND `contests`.`visible_range_show`   = 1)', {id: contest_id}).limit(1) }
  scope :find_result_by_id, -> (contest_id){ where('(`contests`.`id` = :id AND `contests`.`visible_range_result` = 0) OR (`contests`.`limited_url_result` = :id AND `contests`.`visible_range_result` = 1)', {id: contest_id}).limit(1) }


  scope :in_period_entry,    -> (time = Time.current){ where(entry_end_at:   time...Float::INFINITY) }
  scope :in_period_vote,     -> (time = Time.current){ where(entry_end_at:   -Float::INFINITY..time, vote_end_at:  time...Float::INFINITY) }
  scope :in_period_entering, -> (time = Time.current){ where(entry_start_at: -Float::INFINITY..time, entry_end_at: time...Float::INFINITY) }
  scope :in_period_voting,   -> (time = Time.current){ where(vote_start_at:  -Float::INFINITY..time, vote_end_at:  time...Float::INFINITY) }
  scope :in_period_show,     -> (time = Time.current){ where(vote_end_at:    Float::INFINITY..time) }
  scope :in_period_result,   -> (time = Time.current){ where(vote_end_at:    Float::INFINITY..time) }


  # #===nameカラム============================================================
  before_save { self.name = name.gsub(/\A[[:space:]]+|[[:space:]]\z/, "") }
  validates :name,  presence: true,
                    length: { maximum: 255, allow_blank: true }
  # #========================================================================
  # #===descriptionカラム====================================================
  before_save { self.description = '' if self.description.nil? }
  validates :description, presence: false,
                          length: { maximum: 10000 }
  # #========================================================================
  # #===entry_start_atカラム=================================================
  before_validation { self.entry_start_at = Time.current.yesterday unless self.entry_start_at.present? }
  validates :entry_start_at,  presence: true
  validate  :check_entry_start_at_later_than_current
  # #========================================================================
  # #===entry_end_atカラム==================================================
  before_validation { self.entry_end_at = Time.current.yesterday unless self.entry_end_at.present? }
  validates :entry_end_at,  presence: true
  validate  :check_entry_end_at_later_than_entry_start_at
  # #========================================================================
  # #===vote_start_atカラム==================================================
  before_validation { self.vote_start_at = Time.current.yesterday unless self.vote_start_at.present? }
  validates :vote_start_at,  presence: true
  validate  :check_vote_start_at_later_than_entry_end_at
  # #========================================================================
  # #===vote_end_atカラム====================================================
  before_validation { self.vote_end_at = Time.current.yesterday unless self.vote_end_at.present? }
  validates :vote_end_at,  presence: true
  validate  :check_vote_end_at_later_than_vote_start_at
  # #========================================================================
  # #===visible_range_entryカラム============================================
  validates :visible_range_entry, presence: true,
                                  inclusion: {  in: [0, 1],
                                                message: "は正しく選択してください" }
  # #========================================================================
  # #===visible_range_entryカラム============================================
  validates :visible_range_vote,  presence: true,
                                  inclusion: {  in: [0, 1],
                                                message: "は正しく選択してください" }
  # #========================================================================
  # #===visible_range_entryカラム============================================
  validates :visible_range_show,  presence: true,
                                  inclusion: {  in: [0, 1],
                                                message: "は正しく選択してください" }
  # #========================================================================
  # #===visible_range_entryカラム============================================
  validates :visible_range_result,  presence: true,
                                    inclusion: {  in: [0, 1],
                                                  message: "は正しく選択してください" }
  # #========================================================================
  # #===voting_pointsカラム==================================================
  validates :voting_points, presence: true,
                            numericality: { only_integer: true,
                                            greater_than_or_equal_to: 1,
                                            less_than_or_equal_to: 99 }
  # #========================================================================
  # #===num_of_views_in_resultカラム==================================================
  validates :num_of_views_in_result,  presence: true,
                                      numericality: { only_integer: true,
                                                      greater_than_or_equal_to: 1,
                                                      less_than_or_equal_to: 99 }
  # #========================================================================
  # #===num_of_submit_limitカラム==================================================
    validates :num_of_submit_limit, presence: true,
                                    numericality: { only_integer: true,
                                                    greater_than_or_equal_to: 1,
                                                    less_than_or_equal_to: 99 }
  # #========================================================================
  # #===visible_range_entryカラム============================================
  validates :visible_setting_for_user_name, presence: true,
                                            inclusion: {  in: [0, 1, 2],
                                                          message: "は正しく選択してください" }
  # #========================================================================
  # #===limited_url_entryカラム============================================
  validates :limited_url_entry, presence: true,
                                length: { minimum: 16,
                                          maximum: 16,
                                          allow_blank: true }
  # #========================================================================
  #===limited_url_voteカラム============================================
  validates :limited_url_vote, presence: true,
                                length: { minimum: 16,
                                          maximum: 16,
                                          allow_blank: true }
  # #========================================================================
  #===limited_url_showカラム============================================
  validates :limited_url_show, presence: true,
                                length: { minimum: 16,
                                          maximum: 16,
                                          allow_blank: true }
  # #========================================================================
  #===limited_url_resultカラム============================================
  validates :limited_url_result, presence: true,
                                length: { minimum: 16,
                                          maximum: 16,
                                          allow_blank: true }
  # #========================================================================


  def check_entry_start_at_later_than_current
    errors.add(:entry_start_at, "は現在時刻より遅い時間を選択してください") unless Time.current <= self.entry_start_at
  end
  def check_entry_end_at_later_than_entry_start_at
    errors.add(:entry_end_at, "は応募開始時刻より遅い時間を選択してください") unless self.entry_start_at < self.entry_end_at
  end
  def check_vote_start_at_later_than_entry_end_at
    errors.add(:vote_start_at, "は応募終了時刻か応募終了時刻より遅い時間を選択してください") unless self.entry_end_at <= self.vote_start_at
  end
  def check_vote_end_at_later_than_vote_start_at
    errors.add(:vote_end_at, "は投票開始時刻より遅い時間を選択してください") unless self.vote_start_at < self.vote_end_at
  end



  def self.find_contest_entry(contest_id)
    contest = Contest.find_entry_by_id(contest_id)
    contest.present? ? contest[0] : nil
  end
  def self.find_contest_vote(contest_id)
    contest = Contest.find_vote_by_id(contest_id)
    contest.present? ? contest[0] : nil
  end
  def self.find_contest_show(contest_id)
    contest = Contest.find_show_by_id(contest_id)
    contest.present? ? contest[0] : nil
  end
  def self.find_contest_result(contest_id)
    contest = Contest.find_result_by_id(contest_id)
    contest.present? ? contest[0] : nil
  end


  def vote_result
    votes = self.votes
    photos = self.photos.includes(:user, :contest)

    received_votes = {}

    #IDをキー、作品を値にしたハッシュを定義
    #この後の点数計算でキー検索をするので、ハッシュである必要がある
    photos.each do |photo|
      photo.vote_points = 0
      received_votes[:"#{photo.id}"] = photo
    end

    #該当する作品に得点を加算する。
    votes.each do |vote|
      received_votes[:"#{vote.photo_id}"].vote_points += vote.point
    end

    #ハッシュからキーを取り除いて配列にする
    photos_array_has_points = received_votes.map{|key, value| value }

    #ポイント降順 & id昇順 でソート
    photos_array_has_points.sort! do |a, b|
      [-a.vote_points, a.id] <=> [-b.vote_points, b.id]
    end

    now_rank = 1
    result = {}
    result[:rank1], result[:else] = [], []
    i, limit = 0, photos_array_has_points.length
    while i < limit
      #最初の要素は必ず１位
      if i == 0
        photos_array_has_points[i].vote_rank = now_rank
      else
        #1つ小さい番号の要素と比較して得点が小さければ順位が下がる
        now_rank = i + 1 if photos_array_has_points[i].vote_points < photos_array_has_points[i-1].vote_points
        photos_array_has_points[i].vote_rank = now_rank
      end

      #順位が設定値より高くなった時点で終了
      break if now_rank > self.num_of_views_in_result

      if now_rank <= 1
        result[:rank1] << photos_array_has_points[i]
      else
        result[:else] << photos_array_has_points[i]
      end
      i += 1
    end

    result
  end

  def create_limited_url
    self.limited_url_entry = Url.random_id
    self.limited_url_vote = Url.random_id
    self.limited_url_show = Url.random_id
    self.limited_url_result = Url.random_id
  end

  def self.model_labels
    options = {
      name: 'コンテスト名',
      organizer: '主催者',
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
      visible_setting_for_user_name: '応募者名の公開',
      voting_points: '投票者の持ち点',
      num_of_views_in_result: '表示する順位',
      num_of_submit_limit: '作品の提出上限'
    }
  end

  def initialize_for_form
    self.entry_start_at = Time.current
    self.entry_end_at = Time.current
    self.vote_start_at = Time.current
    self.vote_end_at = Time.current
    self.visible_range_entry = 0
    self.visible_range_vote = 0
    self.visible_range_show = 0
    self.visible_range_result = 0
    self.voting_points = 3
    self.num_of_views_in_result = 3
    self.visible_setting_for_user_name = 0
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
    now = Time.current
    options = [{entry_period: { label:  contest_labels[:entry_period],
                                start: {obj:              'entry_start_at',
                                        label:            contest_labels[:entry_start_at]
                                        },
                                end:   {obj:              'entry_end_at',
                                        label:            contest_labels[:entry_end_at]
                                        }},
                vote_period:  { label:  contest_labels[:vote_period],
                                start: {obj:              'vote_start_at',
                                        label:            contest_labels[:vote_start_at]
                                        },
                                end:   {obj:              'vote_end_at',
                                        label:            contest_labels[:vote_end_at]
                                        }}},

              { visible_range_entry:  { options:  select_options[:visible_range_entry],
                                        label:    contest_labels[:visible_range_entry]
                                        },
                visible_range_vote:   { options:  select_options[:visible_range_vote],
                                        label:    contest_labels[:visible_range_vote]
                                        },
                visible_range_show:   { options:  select_options[:visible_range_show],
                                        label:    contest_labels[:visible_range_show]
                                        },
                visible_range_result: { options:  select_options[:visible_range_result],
                                        label:    contest_labels[:visible_range_result]
                                        }},

              { visible_setting_for_user_name: {options:  select_options[:visible_setting_for_user_name],
                                                label:    contest_labels[:visible_setting_for_user_name]
                                                }}]
  end

  def excerpt_description(i = 50)
    description = self.description
    description.length > i ? description[0..i-1] + '...' : description
  end


  def is_in_period_result?
    return self.vote_end_at <= Time.current ? true : false
  end
  def is_in_period_show?
    return self.vote_end_at <= Time.current ? true : false
  end
  def is_after_period_voting?
    return self.vote_end_at <= Time.current ? true : false
  end
  def is_before_period_voting?
    return !self.is_after_period_voting?
  end
  def is_in_period_voting?
    now = Time.current
    return self.vote_start_at <= now && now < self.vote_end_at ? true : false
  end
  def is_after_period_entry?
    return self.entry_end_at <= Time.current ? true : false
  end
  def is_in_period_entry?
    now = Time.current
    return self.entry_start_at <= now && now < self.entry_end_at ? true : false
  end


  def is_already_submitted?(user)
    self.photos.exists?(user: user)
  end
  def is_submitted_limit_times?(user, num)
    self.photos.where(user: user).limit(num).size >= num
  end
  def is_already_voted?(user)
    self.votes.exists?(user: user)
  end
  def is_able_to_submit?(user)
    self.is_in_period_entry? && self.is_submitted_limit_times?(user, self.num_of_submit_limit)
  end
end
