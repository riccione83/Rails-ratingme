class Review < ActiveRecord::Base
	mount_uploader :picture, PictureUploader
	geocoded_by :lat => :lat, :lon => :lon # ActiveRecord
	has_many :ratings
end
