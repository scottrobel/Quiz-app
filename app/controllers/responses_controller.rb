# frozen_string_literal: true

class ResponsesController < ApplicationController
  include QuizzesHelper
  include ResponsesHelper
  before_action :require_quiz_exists, only: %i[new create]
  before_action :require_answers_ids_belong_to_quiz, only: %i[create]
  before_action :require_admin_own_quiz_or_own_response, only: %i[show]
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
      redirect_to @response
    else
      render :new
    end
  end

  def show
    @response = Response.find_by(id: params[:id])
    @user = @response.user
    @quiz = @response.quiz
    @question_answer_pairs = @response.answers.includes(:question).group_by(&:question)
    @chart_position = @response.chart_position
  end

  def index
    @quiz = Quiz.find_by(id: params[:quiz_id])
  end

  private

  def response_params
    params.require(:response).permit(:quiz_id, answer_ids: [], answers_attributes: %i[question_id contents])
  end
end
