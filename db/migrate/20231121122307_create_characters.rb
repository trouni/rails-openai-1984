class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.references :user, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
