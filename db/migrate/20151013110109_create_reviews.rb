class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.decimal :lat, :precision=>64, :scale=>12
      t.decimal :lon, :precision=>64, :scale=>12
      t.string :title
      t.text :description
      t.string :question1
      t.string :question2
      t.string :question3
      t.integer :isAdvertisement
      t.string :adImageLink

      t.timestamps null: false
    end
  end
end
