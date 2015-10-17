class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :review, index: true
      t.integer :user_id
      t.string :user_name
      t.integer :point
      t.text :description
      t.integer :rate_question1
      t.integer :rate_question2
      t.integer :rate_question3

      t.timestamps null: false
    end
  end
end
