# frozen_string_literal: true

module QuizzesHelper
  private

  def require_own_quiz
    unless current_user.quizzes.find_by(id: params[:id])
      flash[:alert] = 'That Quiz is not Yours'
      redirect_to root_path
    end
  end

  def require_admin
    unless current_user &. admin_user?
      flash[:alert] = 'Only Admins Can See That Page!'
      redirect_to root_path
    end
  end

  def require_quiz_exists
    unless Quiz.find_by(id: params[:quiz_id] || response_params[:quiz_id])
      flash[:alert] = 'That quiz does not exist'
      redirect_to root_path
    end
  end

  def require_has_not_taken_quiz
    if Response.find_by(user_id: current_user.id,
                        quiz_id: params[:quiz_id] || response_params[:quiz_id])
      flash[:alert] = 'You already took that quiz'
      redirect_to root_path
    end
  end

  def response_params
    params.require(:response).permit(:quiz_id, questions: [answers: [:contents, answer_ids: []]])
  end
end
