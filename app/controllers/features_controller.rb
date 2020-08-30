class FeaturesController < ApplicationController
  include FeaturesHelper
  before_action :require_admin, only: [:create, :destroy]
  def create
    quiz = Quiz.find_by(params[:quiz_id])
    feature = quiz.build_feature
    if feature.save
      flash[:notice] = "Quiz Featured"
    else
      flash[:notice] = "Something Went Wrong"
    end
    redirect_to quiz_path(quiz.id)
  end

  def destroy
    quiz = Quiz.find_by(id: params[:quiz_id])
    feature = Feature.find_by(quiz_id: params[:quiz_id], id: params[:id])
    if feature.destroy
      flash[:notice] = "Quiz Unfeatured"
    else
      flash[:notice] = "Something Went Wrong"
    end
    redirect_to quiz_path(quiz.id)
  end
end
