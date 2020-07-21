# frozen_string_literal: true

class Response < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :response_answers, dependent: :destroy
  has_many :answers, through: :response_answers, inverse_of: :responses
  accepts_nested_attributes_for :answers

  #== Instance Methods
  def axis_answers_hash
    self.answers.includes(:question).group_by do |answer|
      answer.question.axis
    end
  end

  def chart_points_hash
    points_hash = axis_answers_hash.map do |axis, answers|
      [axis, answers.map(&:value).sum]
    end.to_h
    {'X' => (points_hash['X'] || 0.5), 'Y' => (points_hash['Y'] || 0.5)}
  end

  def chart_position
    quiz = self.quiz
    xy_max = quiz.xy_max
    xy_min = quiz.xy_min
    xy_score = chart_points_hash
    xy_range = {'X' => (xy_max['X'] - xy_min['X']), 'Y' => (xy_max['Y'] - xy_min['Y'])}
    xy_absolute_score = {'X' => (xy_score['X'] - xy_min['X']), 'Y' => (xy_score['Y'] - xy_min['Y'])}
    {'X' => (xy_absolute_score['X'].to_f / xy_range['X'] * 100), 'Y' => (xy_absolute_score['Y'].to_f / xy_range['Y'] * 100)}
  end
end
