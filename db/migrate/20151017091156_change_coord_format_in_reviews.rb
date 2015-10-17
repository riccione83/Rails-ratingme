class ChangeCoordFormatInReviews < ActiveRecord::Migration
  def change
  	 def up
    	change_column :reviews, :lat, :float
    	change_column :reviews, :lon, :float
  	 end

     def down
        change_column :reviews, :lat, :double
        change_column :reviews, :lon, :double
     end
  end
end
