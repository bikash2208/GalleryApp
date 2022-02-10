class AddUserNameToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :user_name, :string
  end
end
