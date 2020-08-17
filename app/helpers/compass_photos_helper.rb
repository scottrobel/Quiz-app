module CompassPhotosHelper
  private

  def require_quiz
    @quiz = Quiz.find_by(id: params[:quiz_id])
  end

  def attach_compass
    if params[:quiz] && params[:quiz][:compass]
      @quiz.compass.attach(params[:quiz][:compass])
    end
  end
end
