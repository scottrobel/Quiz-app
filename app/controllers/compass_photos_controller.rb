class CompassPhotosController < ApplicationController
  include CompassPhotosHelper
  before_action :require_quiz, only: [:new, :create, :destroy]
  def new ; end

  def create
    @quiz.compass.attach(params[:quiz] && params[:quiz][:compass])
    if @quiz.compass.attached?
      flash[:notice] = 'Compass Attached'
      redirect_to quiz_path(@quiz)
    else
      flash[:notice] = "Quiz Updated"
      redirect_to quiz_path(@quiz)
    end
  end

  def destroy
    @quiz.compass.purge_later
    flash[:notice] = 'Compass Photo Changed to default'
    redirect_to quiz_path(@quiz)
  end
end
