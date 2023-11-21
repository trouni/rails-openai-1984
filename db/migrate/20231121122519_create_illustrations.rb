class CreateIllustrations < ActiveRecord::Migration[7.0]
  def change
    create_table :illustrations do |t|
      t.references :user, foreign_key: true
      t.string :image_url
      t.string :character_photo_url
      t.string :situation

      t.timestamps
    end
  end
end
