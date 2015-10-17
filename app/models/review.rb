class Review < ActiveRecord::Base
	has_many :ratings
end
