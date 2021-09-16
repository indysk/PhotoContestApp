class Url
  include Virtus.model
  include ActiveModel::Model
  include ActionView::Helpers

  class << self
    include Rails.application.routes.url_helpers
  end


  #目的
  #限定公開用のURLを作成するためのフォームにモデルをセットするため
  #+αとして、URL生成、表示用の機能をまとめるため

  #方法
  #Contest#showは、URLに関して以下の仕事をしなければならない
    #1.現在限定公開に設定されているページのURLを表示する
    #2.URLの更新ようのフォームを表示する
  #1.Contest ControllerでUrl.new()として、contestの情報を読み取りつつ、2のフォーム用の情報を含む、View用のUrlモデル群を作成
  #2.Contest ControllerでUrl.new(@contest).urls_for_viewとして、View用のURLモデル群を作成することにより、Formに対応


  #フォームから送信されるクエリのコンテストID
  attribute :contest_id, String
  #フォームから送信されるクエリの対象ページ
  attribute :page, String

  #コンテストでURL限定公開に設定されているページ
  attribute :setting_pages, String
  #ビューに反映する値
  attribute :copy_label, String
  attribute :url_value, String
  attr_accessor :contest


  validates_presence_of %i(
    contest_id
    page
  )

  def get_url_params(para)
    self.contest_id = para[:id]
    self.contest = Contest.find_by(id: para[:id])
    self.page = para[:page]
    self.copy_label = Url.model_labels[:"#{para[:page]}"]
  end

  def contest_params
    contest = self.contest
    page = self.page
    url = SecureRandom.alphanumeric(16)
    self.url_value = url
    para = {limited_url_entry: url} if page == 'entry' && contest.visible_range_entry == 1
    para = {limited_url_vote: url} if page == 'vote' && contest.visible_range_vote == 1
    para = {limited_url_show: url} if page == 'show' && contest.visible_range_show == 1
    para = {limited_url_result: url} if page == 'result' && contest.visible_range_result == 1

    para ? para : false
  end

  #現在のコンテストの設定に基づいてView用のハッシュを返す
  #Contest#showでURLを表示するパーシャルで使う
  def urls_for_view(contest)
    self.contest_id = contest.id
    self.setting_pages = current_setting_visible_pages(contest)

    result = []
    labels = Url.model_labels
    self.setting_pages.each do |page|
      url_model = Url.new()
      url_model.contest_id = self.contest_id
      url_model.copy_label = labels[:"#{page}"]
      url_model.page = page
      url_model.url_value = Url.print_limited_url(contest.send("limited_url_#{page}"), page)
      result << url_model
    end
    result
  end

  def self.print_limited_url(url_value, page)
    return '' if url_value == ''
    return contest_url(url_value) if page == 'entry'
    return contest_photos_url(url_value) if page == 'vote'
    return contest_photos_url(url_value) if page == 'show'
    return contest_votes_url(url_value) if page == 'result'
    return false
  end

  def self.model_labels
    result = {
      entry: '提出ページ',
      vote: '投票ページ',
      show: '作品一覧',
      result: '投票結果',
    }
    result
  end

  private
    #コンテストの設定を参照して、URL限定公開になっているページをまとめた配列を出力
    def current_setting_visible_pages(contest)
      result = []
      result << 'entry' if contest.visible_range_entry == 1
      result << 'vote' if contest.visible_range_vote == 1
      result << 'show' if contest.visible_range_show == 1
      result << 'result' if contest.visible_range_result == 1
      result
    end


end
