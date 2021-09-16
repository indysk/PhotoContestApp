class Url
  include Virtus.model
  include ActiveModel::Model

  #目的
  #限定公開用のURLを作成するためのフォームにモデルをセットするため
  #+αとして、URL生成、表示用の機能をまとめるため

  #方法
  #Contest#showは、URLに関して以下の仕事をしなければならない
    #1.現在限定公開に設定されているページのURLを表示する
    #2.URLの更新ようのフォームを表示する
  #1.Contest ControllerでUrl.new(@contest)として、contestの情報を読み取りつつ、2のフォーム用の情報を含む、View用のUrlモデル群を作成
  #2.Contest ControllerでUrl.new(@contest).urls_for_viewとして、View用のURLモデル群を作成することにより、Formに対応



  #フォームから送信されるクエリのコンテストID
  attribute :contest_id, String
  #フォームから送信されるクエリの対象ページ
  attribute :tag, String

  #コンテストでURL限定公開に設定されているページ
  attribute :setting_tags, String
  #ビューに反映する値
  attribute :label, String
  attribute :url_value, String


  validates_presence_of %i(
    contest_id
    tag
  )

  #Contest#showで呼び出された時のため
  def initialize(contest = nil)
    unless cotest.nil?
      self.contest_id = contest.id
      self.setting_tags = self.current_setting_visible_tags(contest)
    end
  end

  def self.create(contest_id, tag)
    if contest = Contest.find_by(id: contest_id)
      url = create_random_id
      contest.limited_url_entry = url if value == 'entry' || contest.visible_range_entry == 1
      contest.limited_url_vote = url if value == 'vote' || contest.visible_range_vote == 1
      contest.limited_url_show = url if value == 'show' || contest.visible_range_show == 1
      contest.limited_url_result = url if value == 'result' || contest.visible_range_result == 1
    else
      return false
    end
    contest.update ? {tag: tag, url_value: url} : false
  end

  #現在のコンテストの設定に基づいてView用のハッシュを返す
  #Contest#showでURLを表示するパーシャルで使う
  def urls_for_view
    result = []
    labels = Url.model_labels
    self.setting_tags.each do |tag|
      url_model = Url.new()
      url_model.contest_id = self.contest_id
      url_model.label = labels[:"#{tag}"]
      url_model.tag = tag
      url_model.url_value = self.contest.send("limited_url_#{tag}")
      result << url_model
    end
    result
  end

  def self.model_labels
    {
      entry: '提出ページ',
      vote: '投票ページ',
      show: '作品一覧',
      result: '投票結果',
    }
  end

  private
    #コンテストの設定を参照して、URL限定公開になっているページをまとめた配列を出力
    def current_setting_visible_tags(contest)
      result = []
      result << 'entry' if contest.visible_range_entry == 1
      result << 'vote' if contest.visible_range_vote == 1
      result << 'show' if contest.visible_range_show == 1
      result << 'result' if contest.visible_range_result == 1
      result
    end


end
