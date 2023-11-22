class CreateIllustrations < ActiveRecord::Migration[7.0]
  def change
    create_table :illustrations do |t|
      t.string :situation

      t.timestamps
    end
  end
end
