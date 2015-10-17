class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.belongs_to :rating, index: true
      t.string :user_name
      t.string :
      t.string :user_email
      t.string :user_city

      t.timestamps null: false
    end
  end
end
