class AddCoversToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :small_cover, :string
    add_column :videos, :large_cover, :string
  end
end