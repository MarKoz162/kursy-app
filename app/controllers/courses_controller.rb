class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_course, only: [ :show, :destroy, :approve, :unapprove, :statistics ]
  before_action :set_tags, expect: [:statistics, :create, :destroy, :show, :new]
  
  def index
     @ransack_path = courses_path
     @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    
     @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :course_tags => :tag))
  end
  
  def statistics
    authorize @course, :owner?
  end
  
  def approve
    authorize @course, :approve?
    @course.update_attribute(:approved, true )
    redirect_to @course, notice: "Course approved and visible"
  end  
  
  def unapprove
    authorize @course, :unapprove?
    @course.update_attribute(:approved, false )
    redirect_to @course, notice: "Course unapproved and hidden"
  end  
  
  def unapproved
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.unapproved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end  
  
  def purchased
    @ransack_path = purchased_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end
  
  
  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end
  
  def created
    @ransack_path = created_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end  
  
  def show
    authorize @course
    @lessons = @course.lessons.rank(:row_order)
    @enrollments_with_review = @course.enrollments.reviewed
    @tags = Tag.all
  end

  def new
    @course = Course.new
    authorize @course
    @tags = Tag.all
  end

  def create
    @course = Course.new(course_params)
    authorize @course
    @course.description = 'Description'
    @course.short_description = 'Short Description'
    @course.user = current_user
    respond_to do |format|
      if @course.save
        format.html { redirect_to course_course_creator_index_path(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        @tags = Tag.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @course
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to @course, alert: "Course has enrollments, and can't be deleted"
    end  
  end

  private
   
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :description, :short_description, :price, :level, :language, :published, :avatar, tag_ids: [])
    end
    
    def set_tags
      @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    end
end
