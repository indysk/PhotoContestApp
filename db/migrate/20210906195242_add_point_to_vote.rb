class AddPointToVote < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :point, :integer, null: false
  end
end
