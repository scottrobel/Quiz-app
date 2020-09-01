# frozen_string_literal: true

class QuizzesController < ApplicationController
  include QuizzesHelper
  before_action :authenticate_user!, except: [:index]
  before_action :require_own_quiz_or_admin, only: %i[edit update destroy]
  def new
    @quiz = Quiz.new
  end

  def show
    @quiz = Quiz.find_by(id: params[:id])
  end

  def users_quizzes
    if current_user.admin_user?
      @quizzes = Quiz.all
    else
      @quizzes = current_user.quizzes
    end
  end

  def index
    @quizzes = Quiz.all
    if params['sort_method'] == 'response_count' || params[:sort_method].nil?
      @quizzes = @quizzes.order('responses_count DESC')
    elsif params['sort_method'] == 'created_at'
      @quizzes = @quizzes.order('created_at DESC')
    end
    respond_to do |format|
      format.js { }
      format.html {}
    end
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
        redirect_to new_quiz_compass_photo_path(@quiz)
      end
    end
    @quiz.questions.to_a.each(&:create_default_answers)
    @quiz.create_indexes
    respond_to do |format|
      format.js {}
    end
  end

  def edit
    @quiz = Quiz.find_by(id: params[:id])
    @quiz.create_indexes
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
        redirect_to quiz_path(@quiz)
      end
    end
    @quiz.questions.to_a.each(&:update_default_answers)
    @quiz.create_indexes
    
    respond_to do |format|
      format.js {}
    end
  end

  def destroy
    @quiz = Quiz.find_by(id: params[:id])
    if @quiz.destroy
      flash[:notice] = "'#{@quiz.title}' Deleted"
      redirect_to users_quizzes_path
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:compass, :title, :top_label, :bottom_label, :right_label, :left_label, questions_attributes: [:index, :axis, :contents, :question_type, :_destroy, answers_attributes: %i[index value contents _destroy]])
  end

  def quiz_update_params
    params.require(:quiz).permit(:top_label, :bottom_label, :right_label, :left_label, :title, :id, questions_attributes: [:index, :axis, :contents, :question_type, :_destroy, :id, answers_attributes: %i[index value contents _destroy id]])
  end
end
