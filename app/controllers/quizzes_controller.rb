# frozen_string_literal: true

class QuizzesController < ApplicationController
  include QuizzesHelper
  before_action :authenticate_user!
  before_action :require_admin, except: [:index]
  before_action :require_own_quiz, only: %i[edit update]
  def new
    @question_type_input = [["open ended", "open_ended"], ["select one", "select_one"], ["select multiple", "select_multiple"]]
    @quiz = Quiz.new
  end

  def show
    @quiz = Quiz.find_by(id: params[:id])
  end

  def users_quizzes
    @quizzes = current_user.quizzes
  end

  def index
    @quizzes = Quiz.all - current_user.taken_quizzes
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.creator = current_user
    if params[:commit] == 'Add Question'
      @quiz.questions.build
    elsif params[:commit].match?(/Add Option to question \d+/)
      question_number = params[:commit].match(/Add Option to question (\d+)/)[1].to_i - 1
      @quiz.questions[question_number].answers.build
    elsif params[:commit] == 'Create Quiz'
      if @quiz.save
        flash[:notice] = 'Quiz Created'
        redirect_to quizzes_path
      end
    end
    respond_to do |format|
      format.html { render :new }
      format.js {}
    end
  end

  def edit
    @quiz = Quiz.find_by(id: params[:id])
  end

  def update
    @quiz = Quiz.find_by(id: params[:id])
    if @quiz.update(quiz_update_params)
      if params[:commit] == 'Add Question'
        @quiz.questions.build
      elsif params[:commit].match?(/Add Option to question \d+/)
        question_number = params[:commit].match(/Add Option to question (\d+)/)[1].to_i - 1
        @quiz.questions[question_number].choices.build
      elsif params[:commit] == 'Update Quiz'
        flash[:notice] = 'Quiz Updated'
        redirect_to root_path
      end
    end
    respond_to do |format|
      format.html { render :edit }
      format.js {}
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title, questions_attributes: [:contents, :question_type, :_destroy, answers_attributes: %i[contents _destroy]])
  end

  def quiz_update_params
    params.require(:quiz).permit(:title, :id, questions_attributes: [:contents, :question_type, :_destroy, :id, answers_attributes: %i[contents _destroy id]])
  end
end
