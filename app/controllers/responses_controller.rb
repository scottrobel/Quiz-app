class ResponsesController < ApplicationController
  include QuizzesHelper
  before_action :require_quiz_exists, only: [:new]
  before_action :authenticate_user!
  before_action :require_admin, only: [:show]
  before_action :require_has_not_taken_quiz, only: [:new]
  def new
    quiz = Quiz.find_by(id: params[:quiz_id])
    @response = Response.new
    @response.quiz = quiz
  end

  def create
    response = build_response
    if save_question_answers && response.save
      flash[:notice] = "Response Recorded!"
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def build_response
    response = Response.new
    response.quiz_id = response_params[:quiz_id]
    response.user = current_user
    @pending_question_answers = []
    response_params[:questions].each do |question_id, question_params|
      answer_params = question_params[:answers]
      case Question.find_by(id: question_id).question_type
      when 'open_ended'
        build_open_ended_answer(response, answer_params, question_id)
      when 'select_one'
        build_radio_answer(response, answer_params, question_id)
      when 'multiple_choice'
        build_selection_answer(response, answer_params, question_id)
      end
    end
    response
  end

  def build_open_ended_answer(response, answer_params, question_id)
    answer = response.answers.build(answer_params)
    answer.question_answers.build(question_id: question_id)
  end

  def build_radio_answer(response, answer_params, question_id)
    answer_ids = remove_blank_answer_ids(answer_params[:answer_ids])
    answer_id = answer_ids.first
    response_answer = response.response_answers.build(answer_id: answer_id)
    question_answer = QuestionAnswer.new(question_id: question_id, answer_id: answer_id)
    @pending_question_answers << question_answer
  end

  def build_selection_answer(response, answer_params, question_id)
    answer_ids = remove_blank_answer_ids(answer_params[:answer_ids])
    answer_ids.each do |answer_id|
      response_answer = response.response_answers.build(answer_id: answer_id)
      question_answer = QuestionAnswer.new(question_id: question_id, answer_id: answer_id)
      @pending_question_answers << question_answer
    end
  end

  def save_question_answers
    @pending_question_answers.each(&:save)
  end

  def response_params
    params.require(:response).permit(:quiz_id, questions: [answers: [:contents, answer_ids: []]])
  end

  # rails inserts a hidden blank field
  # this removes it
  def remove_blank_answer_ids(answer_ids)
    answer_ids.select do |answer_id|
      !answer_id.blank?
    end
  end
end