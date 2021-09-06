class AddColumsToPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :photographer, :string #撮影者のニックネーム
    add_column :photos, :description, :text #作品の説明
    add_column :photos, :camera, :string #カメラの名前
    add_column :photos, :lens, :string #カメラのレンズ
    add_column :photos, :iso, :string #ISO
    add_column :photos, :aperture, :string #絞り
    add_column :photos, :shutter_speed, :string #シャッター速度
    add_column :photos, :image, :string
  end
end
