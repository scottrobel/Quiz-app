# frozen_string_literal: true

class Quiz < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions
  has_many :responses, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true
  
  #== Instance Methods


  def axis_question_hash
    self.questions.includes(:answers).group_by(&:axis)
  end

  def xy_max
    axis_max_values = axis_question_hash.map do |axis, questions|
      max_value = questions.map do |question|
        question.answers.map(&:value).max
      end.sum
      [axis, max_value]
    end.to_h
    {'X' => axis_max_values['X'], 'Y' => axis_max_values['Y']}
  end

  def xy_min
    axis_max_values = axis_question_hash.map do |axis, questions|
      max_value = questions.map do |question|
        question.answers.map(&:value).min
      end.sum
      [axis, max_value]
    end.to_h
    {'X' => (axis_max_values['X'] || 0), 'Y' => (axis_max_values['Y'] || 0)}
  end
end
