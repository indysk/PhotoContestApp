class RemoveColumnPhotographerFromPhoto < ActiveRecord::Migration[5.2]
  def change
    #ログイン必須としたため、撮影者のニックネームでなくユーザ名を使うことにした
    remove_column :photos, :photographer, :string
  end
end
