# frozen_string_literal: true

module QuizzesHelper
  private

  def require_own_quiz_or_admin
    unless current_user.quizzes.find_by(id: params[:id]) || current_user.admin_user?
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

  def require_admin_or_own_response
    unless current_user.admin_user? || Response.find_by(id: params[:id]).user_id == current_user.id
      flash[:alert] = 'You must be an admin to view other users Responses!'
      redirect_to root_path
    end
  end

  def delete_button_params(type, question_index, choice_index = nil)
    case type
    when 'question'
      { param_key: "quiz[questions_attributes][#{question_index}][_destroy]" }
    when 'choice'
      { param_key: "quiz[questions_attributes][#{question_index}][answers_attributes][#{choice_index}][_destroy]" }
    end
  end
end
