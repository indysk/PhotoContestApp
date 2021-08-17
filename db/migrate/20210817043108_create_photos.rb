class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos, id: :string do |t|
      t.string :name
      t.string :user_id
      t.string :contest_id

      t.timestamps
    end
    add_foreign_key :photos, :users
    add_foreign_key :photos, :contests
  end
end
