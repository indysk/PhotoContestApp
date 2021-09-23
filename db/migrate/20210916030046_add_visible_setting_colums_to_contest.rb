class AddVisibleSettingColumsToContest < ActiveRecord::Migration[5.2]
  def change
    add_column :contests, :limited_url_entry, :string, null: false, default: ""
    add_column :contests, :limited_url_vote, :string, null: false, default: ""
    add_column :contests, :limited_url_show, :string, null: false, default: ""
    add_column :contests, :limited_url_result, :string, null: false, default: ""

    add_index :contests, :limited_url_entry
    add_index :contests, :limited_url_vote
    add_index :contests, :limited_url_show
    add_index :contests, :limited_url_result
  end
end
