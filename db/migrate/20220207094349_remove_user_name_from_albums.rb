class RemoveUserNameFromAlbums < ActiveRecord::Migration[7.0]
  def change
    remove_column :albums, :user_name, :string
  end
end
