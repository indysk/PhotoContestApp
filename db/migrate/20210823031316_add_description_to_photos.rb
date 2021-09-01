class AddDescriptionToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :contests, :description, :text

    #期間の設定
    add_column :contests, :entry_start_at, :datetime, null: false #作品の応募開始日時
    add_column :contests, :entry_end_at, :datetime, null: false #作品の応募終了日時
    add_column :contests, :vote_start_at, :datetime, null: false #コンテストの投票開始日時　
    add_column :contests, :vote_end_at, :datetime, null: false #コンテストの投票終了日時

    #公開範囲の設定項目
    add_column :contests, :visible_range_entry, :integer, null: false #応募ページ公開範囲
    add_column :contests, :visible_range_vote, :integer, null: false #投票ページの公開範囲
    add_column :contests, :visible_range_show, :integer, null: false #作品一覧の公開範囲
    add_column :contests, :visible_range_result, :integer, null: false #投票結果の公開範囲

    #投票の設定
    add_column :contests, :voting_points, :integer, null: false #投票の持ち点

    #投票結果表示の設定
    add_column :contests, :num_of_views_in_result, :integer, null: false #上位何人の作品を表示するか
    add_column :contests, :visible_setting_for_user_name, :integer, null: false #作品の応募者名の公開範囲


  end
end
