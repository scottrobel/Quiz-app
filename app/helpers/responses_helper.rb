# frozen_string_literal: true

module ResponsesHelper
  private

  def require_answers_ids_belong_to_quiz
    quiz_id = response_params[:quiz_id]
    quiz = Quiz.find_by(id: quiz_id)
    quiz_answers_ids = quiz.answers.pluck(:id)
    submitted_ids = response_params[:answer_ids].reject(&:blank?).map(&:to_i)
    unless submitted_ids_belong_to_quiz(quiz_answers_ids, submitted_ids)
      flash[:alert] = "You have submitted answers that do not belong to that quiz!"
      redirect_to root_path
    end
  end

  def submitted_ids_belong_to_quiz(quiz_answers_ids, submitted_ids)
    submitted_ids.all? do |submitted_id|
      quiz_answers_ids.include?(submitted_id)
    end
  end
end
