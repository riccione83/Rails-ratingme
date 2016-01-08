module ReviewsHelper

    public
    
      def search_by_place
          session[:search_by_place] = 1
      end

      def get_avg_for_review(rev)
        
        #please fix this. it's horrible!!
        
        if rev.question3 != "" and rev.question2 != ""
          return (get_point_question1(rev) + get_point_question2(rev) + get_point_question3(rev)) / total
        end  
        
        if rev.question3 == "" and rev.question2 != ""
         return (get_point_question1(rev) + get_point_question2(rev)) / 2
        end
        
        if rev.question3 != "" and rev.question2 == ""
         return (get_point_question1(rev) + get_point_question3(rev)) / 2
        end
      
        #return (get_point_question1(rev) + get_point_question2(rev) + get_point_question3(rev)) / total
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
	  
	    def current_user
        return session[:current_user_id]
      end
      
      
      #TODO -  NOT ELEGANT - FIX IT!!
      def star_rating(point)
        if point == 0
          raw [
            image_tag('star-off.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png')
          ].join()
        elsif point == 1
          raw [
            image_tag('star-on.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png')
          ].join()
         elsif point == 2
          raw [
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png')
          ].join()
         elsif point == 3
          raw [
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-off.png'),
            image_tag('star-off.png')
          ].join()
         elsif point == 4
          raw [
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-off.png')
          ].join()
         elsif point == 5
          raw [
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-on.png'),
            image_tag('star-on.png')
          ].join()
        end
      end
end
