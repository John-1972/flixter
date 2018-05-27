class Instructor::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: [:show]

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.create(course_params)
    if @course.valid?
      redirect_to instructor_course_path(@course)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @section = Section.new
    @lesson = Lesson.new
  end

  private

  def require_authorized_for_current_course # Define this method
    if current_course.user != current_user # If current_user isn't on the current_course.user list
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  helper_method :current_course
  def current_course
    @current_course ||= Course.find(params[:id]) # Copy all info from Course table for this course
    # (ID'd in the URL) into the current_course instance variable
  end

  def course_params
    params.require(:course).permit(:title, :description, :cost, :image)
  end
end