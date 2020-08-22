# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @quizzes = Quiz.all
  end
end
