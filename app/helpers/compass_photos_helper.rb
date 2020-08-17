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
  def require_own_quiz_or_admin
    unless current_user.quizzes.find_by(id: params[:id]) || current_user.admin_user?
      flash[:alert] = 'That Quiz is not Yours'
      redirect_to root_path
    end
  end
end
