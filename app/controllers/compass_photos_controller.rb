class CompassPhotosController < ApplicationController
  include CompassPhotosHelper
  before_action :require_quiz, only: [:new, :create, :destroy, :edit, :update]
  before_action :attach_compass, only: [:create, :update]
  def new ; end

  def create
    if @quiz.compass.attached?
      flash[:notice] = 'Compass Attached'
    else
      flash[:notice] = "Quiz Updated"
    end
    redirect_to quiz_path(@quiz)
  end

  def destroy
    @quiz.compass.purge_later
    flash[:notice] = 'Compass Photo Changed to default'
    redirect_to quiz_path(@quiz)
  end

  def edit ; end

  def update
    if @quiz.compass.attached?
      if params[:quiz] && params[:quiz][:compass]
        @quiz.compass.attach(params[:quiz][:compass])
        flash[:notice] = "Compass Photo Changed"
      else
        flash[:notice] = "No Changes were made"
      end
    else
      if params[:quiz] && params[:quiz][:compass]
        @quiz.compass.attach(params[:quiz][:compass])
        flash[:notice] = "Compass Photo Added"
      else
        flash[:notice] = "Compass Still Set to default"
      end
    end
    redirect_to quiz_path(@quiz)
  end
end
