# frozen_string_literal: true

class Quiz < ApplicationRecord
  #== File Attachments
  has_one_attached :compass
  
  #== Associations
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
      end.compact.sum
      [axis, max_value]
    end.to_h
    {'X' => axis_max_values['X'], 'Y' => axis_max_values['Y']}
  end

  def xy_min
    axis_max_values = axis_question_hash.map do |axis, questions|
      max_value = questions.map do |question|
        question.answers.map(&:value).min
      end.compact.sum
      [axis, max_value]
    end.to_h
    {'X' => axis_max_values['X'], 'Y' => axis_max_values['Y']}
  end

  def update_indexes
    self.questions.to_a.sort_by(&:index).each_with_index do |question, question_index|
      question.index = question_index
      question.save
      question.answers.order(:index).each_with_index do |answer, answer_index|
        answer.index = answer_index
        answer.save
      end
    end
  end

  def create_indexes
    self.questions.to_a.sort_by(&:index).each_with_index do |question, question_index|
      question.index = question_index
      question.answers.to_a.sort_by(&:index).each_with_index do |answer, answer_index|
        answer.index = answer_index
      end
    end
  end
end
