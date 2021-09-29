class AddNumOfSubmitLimitToContests < ActiveRecord::Migration[5.2]
  def change
    #提出制限回数
    add_column :contests, :num_of_submit_limit, :integer, null: false, default: 1
  end
end
