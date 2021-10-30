module CoursesHelper
  def review_button(course)
    user_course = course.enrollments.where(user: current_user)
    if current_user
      if user_course.any?
        if user_course.pending_review.any?
          link_to 'Add areview', edit_enrollment_path(user_course.first)
        else
          link_to 'You have left a review.', enrollment_path(user_course.first)
        end  
      end      
    end    
  end      
end
