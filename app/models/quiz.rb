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
  
  def xy_max
    {'X' => axis_min_max("X", "max"), 'Y' => axis_min_max("Y", "max")}
  end

  def xy_min
    {'X' => axis_min_max("X", "min"), 'Y' => axis_min_max("Y", "min")}
  end

  def update_indexes
    Task.transaction do
      self.questions.to_a.sort_by(&:index).each_with_index do |question, question_index|
        question.index = question_index
        question.save
        question.answers.order(:index).each_with_index do |answer, answer_index|
          answer.index = answer_index
          answer.save
        end
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

  private

  def axis_min_max(axis, min_or_max)
    min_or_max = min_or_max == "min" ? "min" : "max"
    self.questions
      .joins("INNER JOIN answers ON answers.question_id = questions.id")
      .having("questions.axis = ?", axis)
      .group('questions.id')
      .pluck("#{min_or_max}(answers.value)").sum
  end
end
