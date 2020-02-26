module QuizzesHelper
  private

  def require_own_quiz
    unless current_user.quizzes.find_by(id: params[:id])
      flash[:alert] = "That Quiz is not Yours"
      redirect_to root_path
    end
  end

  def require_admin
    unless current_user &. admin_user?
      flash[:alert] = "Only Admins Can See That Page!"
      redirect_to root_path
    end
  end

  def require_quiz_exists
    unless Quiz.find_by(id: params[:quiz_id])
      flash[:alert] = "That quiz does not exist"
      redirect_to root_path
    end
  end
end
