class Rating < ActiveRecord::Base
	require 'obscenity/active_model'
	
	validates :rate_question1, :presence => true, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5 }
	validates :description, obscenity: { sanitize: true, replacement: :stars }
#	validates :rate_question2, :numericality => { :greater_than => 0, :less_than_or_equal_to => 5 }
#	validates :rate_question3, :numericality => { :greater_than => 0, :less_than_or_equal_to => 5 }
	
	belongs_to :review
	belongs_to :user
end
