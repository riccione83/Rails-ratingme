class Rating < ActiveRecord::Base
	
	validates :rate_question1, :presence => true, :numericality => { :greater_than => 0, :less_than_or_equal_to => 5 }
#	validates :rate_question2, :numericality => { :greater_than => 0, :less_than_or_equal_to => 5 }
#	validates :rate_question3, :numericality => { :greater_than => 0, :less_than_or_equal_to => 5 }
	
	belongs_to :review
	belongs_to :user
end
