class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes, id: :string do |t|
      t.string :contest_id, foreign_key: true, null: false
      t.string :photo_id, foreign_key: true, null: false
      t.string :user_id, foreign_key: true, null: false

      t.timestamps
    end
    add_foreign_key :votes, :contests
    add_foreign_key :votes, :photos
    add_foreign_key :votes, :users
  end
end
