module ReviewsHelper

    public
    
      def search_by_place
          session[:search_by_place] = 1
      end


      def get_total_count_for_question1(rev)
            rev.ratings.count(:rate_question1)
      end
    
      def get_point_question1(rev)
          num_of_ratings = get_total_count_for_question1(rev)
          if num_of_ratings > 0
		        return rev.ratings.sum(:rate_question1) / num_of_ratings
		  else
		        return 0
		  end
	  end
	  
	  def get_total_count_for_question2(rev)
            rev.ratings.count(:rate_question2)
      end
      
      def get_point_question2(rev)
          num_of_ratings = get_total_count_for_question2(rev)
          if num_of_ratings > 0
		        return rev.ratings.sum(:rate_question2) / num_of_ratings
		  else
		        return 0
		  end
	  end
	  
	  def get_total_count_for_question3(rev)
            rev.ratings.count(:rate_question3)
      end
	  
      def get_point_question3(rev)
          num_of_ratings = get_total_count_for_question3(rev)
          if num_of_ratings > 0
		        return rev.ratings.sum(:rate_question3) / num_of_ratings
		  else
		        return 0
		  end
	  end
end
