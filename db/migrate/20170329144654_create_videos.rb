class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :category_id
      t.string :title
      t.text :description
      t.timestamps
    end
  end
end
