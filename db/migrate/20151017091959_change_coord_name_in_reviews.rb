class ChangeCoordNameInReviews < ActiveRecord::Migration
  
  def change
    rename_column :reviews, :lat, :latitude
    rename_column :reviews, :lon, :longitude 
  end

end
