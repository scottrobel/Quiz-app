# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @quizzes = Quiz.all.joins("INNER JOIN features ON features.quiz_id = quizzes.id").order("features.created_at DESC")
  end
end
