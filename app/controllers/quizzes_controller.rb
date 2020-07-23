# frozen_string_literal: true

class QuizzesController < ApplicationController
  include QuizzesHelper
  before_action :authenticate_user!
  before_action :require_own_quiz, only: %i[edit update]
  def new
    @quiz = Quiz.new
  end

  def show
    @quiz = Quiz.find_by(id: params[:id])
  end

  def users_quizzes
    @quizzes = current_user.quizzes
  end

  def index
    @quizzes = Quiz.all
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.creator = current_user
    if params['change-action'] == 'add-question'
      @quiz.questions.build(index: @quiz.questions.to_a.count)
    elsif params['change-action'] == 'add-option'
      question_number = params['question-index'].to_i
      question = @quiz.questions.to_a.find{|question| question.index == question_number}
      question = question.answers.build(index: question.answers.to_a.count)
    elsif params[:commit] == 'Create Quiz'
      if @quiz.save
        flash[:notice] = 'Quiz Created'
        redirect_to quizzes_path
      end
    end
    @quiz.questions.to_a.sort_by(&:index).each_with_index do |question, question_index|
      question.index = question_index
      question.answers.to_a.sort_by(&:index).each_with_index do |answer, answer_index|
        answer.index = answer_index
      end
    end
    respond_to do |format|
      format.js {}
    end
  end

  def edit
    @quiz = Quiz.find_by(id: params[:id])
  end

  def update
    @quiz = Quiz.find_by(id: params[:id])
    if @quiz.update(quiz_update_params)
      if params['change-action'] == 'add-question'
        @quiz.questions.build(index: @quiz.questions.to_a.count)
      elsif params['change-action'] == 'add-option'
        question_number = params['question-index'].to_i
        question = @quiz.questions.to_a.find{|question| question.index == question_number}
        question = question.answers.build(index: question.answers.to_a.count)
      elsif params[:commit] == 'Update Quiz'
        flash[:notice] = 'Quiz Updated'
        redirect_to root_path
      end
    end
    @quiz.questions.order(:index).each_with_index do |question, question_index|
      question.index = question_index
      question.answers.order(:index).each_with_index do |answer, answer_index|
        answer.index = answer_index
      end
    end
    respond_to do |format|
      format.js {}
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title, :top_label, :bottom_label, :right_label, :left_label, questions_attributes: [:index, :axis, :contents, :question_type, :_destroy, answers_attributes: %i[index value contents _destroy]])
  end

  def quiz_update_params
    params.require(:quiz).permit(:top_label, :bottom_label, :right_label, :left_label, :title, :id, questions_attributes: [:index, :axis, :contents, :question_type, :_destroy, :id, answers_attributes: %i[index value contents _destroy id]])
  end
end
