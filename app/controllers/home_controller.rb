class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @latest_courses = Course.latest
    @latest_good_reviews = Enrollment.reviewed.latest_good_review
    @top_rated_courses = Course.top_rated
    @popular_courses = Course.popular
    @purchased_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc).limit(3)
  end
  
  def activity
    if current_user&.has_role?(:admin)
     @pagy, @activities = pagy(PublicActivity::Activity.all.order(created_at: :desc))
    else
      redirect_to root_path, alert: "You don't have access to this page"
    end  
  end 
  
  def statistics
    if current_user&.has_role?(:admin)
      @enrollments = Enrollment.all
      @courses = Course.all
    else
      redirect_to root_path, alert: "You don't have access to this page"
    end
  end  
  
end
