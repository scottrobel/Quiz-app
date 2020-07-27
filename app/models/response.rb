# frozen_string_literal: true

class Response < ApplicationRecord
  belongs_to :quiz, counter_cache: true
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
    {'X' => (axis_position(xy_min['X'], xy_max['X'], xy_score['X']) rescue 50), 'Y' => (axis_position(xy_min['Y'], xy_max['Y'], xy_score['Y'])rescue 50)}
  end

  private

  def axis_position(min, max, score)
    range = max - min
    absolute_score = score - min
    100 - (absolute_score.to_f / range * 100)
  end
end
