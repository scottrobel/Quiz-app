module CompassPhotosHelper
  private

  def require_quiz
    @quiz = Quiz.find_by(id: params[:quiz_id])
  end
end
