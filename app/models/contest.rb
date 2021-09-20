class Contest < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :votes, dependent: :destroy

  scope :public_all, -> (time = Time.current){ where('( :time < `contests`.`entry_end_at` AND  `contests`.`visible_range_entry` = 0 ) OR ( `contests`.`entry_end_at` <= :time AND :time < `contests`.`vote_end_at` AND `contests`.`visible_range_vote` = 0 ) OR ( `contests`.`vote_end_at` <= :time AND ( `contests`.`visible_range_show` = 0 OR `contests`.`visible_range_result` = 0 ) )', {time: time}) }
  scope :public_page, -> (page){ where(:"visible_range_#{page}" => 0)}
  scope :private_page, -> (page){ where(:"visible_range_#{page}" => 1)}

  scope :in_period_entry, -> (time = Time.current){ where(entry_end_at: time...Float::INFINITY) }
  scope :in_period_vote, -> (time = Time.current){ where(entry_end_at: -Float::INFINITY..time, vote_end_at: time...Float::INFINITY) }
  scope :in_period_result, -> (time = Time.current){ where(vote_end_at: Float::INFINITY..time) }


  # #===nameカラム============================================================
  before_save { self.name = name.gsub(/\A[[:space:]]+|[[:space:]]\z/, "") }
  validates :name,  presence: true,
                    length: { maximum: 255, allow_blank: true }
  # #========================================================================

  def self.find_contest_entry(contest_id)
    Contest.public_page('entry').find_by(id: contest_id) || Contest.find_by(limited_url_entry: contest_id)
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


  def is_already_submitted?(current_user)
    self.photos.exists?(user: current_user)
  end
  def is_already_voted?(current_user)
    self.votes.exists?(user: current_user)
  end
  def is_able_to_submit?(current_user)
    self.is_in_period_entry? && self.is_already_submitted?(current_user)
  end

  def find_contest

  end
end
