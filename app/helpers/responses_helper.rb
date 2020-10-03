# frozen_string_literal: true

module ResponsesHelper
  private

  def require_answers_ids_belong_to_quiz
    if response_params[:answer_ids]
      quiz_id = response_params[:quiz_id]
      quiz = Quiz.find_by(id: quiz_id)
      quiz_answers_ids = quiz.answers.pluck(:id)
      submitted_ids = response_params[:answer_ids].reject(&:blank?).map(&:to_i)
      unless submitted_ids_belong_to_quiz(quiz_answers_ids, submitted_ids)
        flash[:alert] = 'You have submitted answers that do not belong to that quiz!'
        redirect_to root_path
      end
    end
  end

  def submitted_ids_belong_to_quiz(quiz_answers_ids, submitted_ids)
    submitted_ids.all? do |submitted_id|
      quiz_answers_ids.include?(submitted_id)
    end
  end

  def require_admin_own_quiz_or_own_response
    response = Response.find(params[:id].to_i)
    if !(current_user.admin_user? || response.quiz.creator_id == current_user.id || response.user_id == current_user.id || response.user.guest_user?)
      flash[:alert] = "You don't have access to that response"
      redirect_to root_path
    end
  end
end
