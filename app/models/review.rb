class Review < ActiveRecord::Base
	geocoded_by :lat => :lat, :lon => :lon # ActiveRecord
	has_many :ratings
end
