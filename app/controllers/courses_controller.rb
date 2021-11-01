class CoursesController < ApplicationController
  before_action :set_course, only: [ :show, :edit, :update, :destroy, :approve, :unapprove ]

  # GET /courses or /courses.json
  def index
    #if params[:title]
      #@courses = Course.where("title ILIKE ?", "%"+params[:title]+"%")
    #else
      #@q = Course.ransack(params[:q])
      #@courses = @q.result.includes(:user)
      @ransack_path = courses_path
      @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
      #@courses = @ransack_courses.result.includes(:user)
      
      @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    #end
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
    @lessons = @course.lessons
    @enrollments_with_review = @course.enrollments.reviewed
  end

  def new
    @course = Course.new
    authorize @course
  end

  def edit
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    authorize @course
    @course.user = current_user
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
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
      params.require(:course).permit(:title, :description, :short_description, :price, :level, :language, :published)
    end
end
