class CreateContests < ActiveRecord::Migration[5.2]
  def change
    create_table :contests, id: :string do |t|
      t.string :name
      t.string :user_id

      t.timestamps
    end
    add_foreign_key :contests, :users
  end
end
