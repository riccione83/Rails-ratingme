class Review < ActiveRecord::Base
	require 'obscenity/active_model'
	mount_uploader :picture, PictureUploader
	geocoded_by :lat => :lat, :lon => :lon # ActiveRecord
	validates :title, obscenity: { sanitize: true, replacement: :stars }
	validates :description, obscenity: { sanitize: true, replacement: :stars }
	validates :question1, obscenity: { sanitize: true, replacement: :stars }
	validates :question2, obscenity: { sanitize: true, replacement: :stars }
	validates :question3, obscenity: { sanitize: true, replacement: :stars }	
	has_many :ratings
	belongs_to :category
	
	def self.search(search)
			where("lower(description) LIKE '%#{search.downcase}%' OR lower(title) LIKE '%#{search.downcase}%'")
	  	#	where("description LIKE ?", "%#{search}%")
  		#	where("title LIKE ?", "%#{search}%")
	end
end
