# frozen_string_literal: true

class ResponsesController < ApplicationController
  include QuizzesHelper
  before_action :require_quiz_exists, only: %i[new create]
  before_action :authenticate_user!
  before_action :require_admin, only: %i[index]
  before_action :require_has_not_taken_quiz, only: %i[new create]
  before_action :require_admin_or_own_response, only: %i[show]
  def new
    quiz = Quiz.find_by(id: params[:quiz_id])
    @response = Response.new
    @response.quiz = quiz
  end

  def create
    @response = Response.new(response_params)
    @response.user = current_user
    if @response.save
      flash[:notice] = 'Response Recorded!'
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @response = Response.find_by(id: params[:id])
    @user = @response.user
    @question_answer_pairs = @response.answers.includes(:question).group_by do |answer|
      answer.question
    end
  end

  def index
    @quiz = Quiz.find_by(id: params[:quiz_id])
  end

  private

  def response_params
    params.require(:response).permit(:quiz_id, answer_ids: [],answers_attributes: [:question_id, :contents])
  end
end
