class AddUserIdAndPublishToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :user_id, :integer
    add_column :albums, :publish, :boolean
  end
end
