class Review < ActiveRecord::Base
	mount_uploader :picture, PictureUploader
	geocoded_by :lat => :lat, :lon => :lon # ActiveRecord
	has_many :ratings
	
	
	def self.search(search)
  		where("description LIKE ?", "%#{search}%") 
  		where("title LIKE ?", "%#{search}%")
	end
end
