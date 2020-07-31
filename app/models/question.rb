# frozen_string_literal: true

class Question < ApplicationRecord
  enum question_type: %i[open_ended drop_down check_boxes agree_equals_positive agree_equals_negitive]
  belongs_to :quiz
  has_many :responses, through: :quiz
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true

  #== Scopes

  default_scope { order(:index) }

  #== Instance Methods

    def axis_positive_end
    if self.axis == 'X'
      self.quiz.left_label
    else
      self.quiz.top_label
    end
  end

  def axis_negitive_end
    if self.axis == 'X'
      self.quiz.right_label
    else
      self.quiz.bottom_label
    end
  end

  def create_default_answers
    if ["agree_equals_positive", "agree_equals_negitive"].include?(self.question_type)
      answer_array = self.default_answer_params.map do |params|
        Answer.new(params)
      end
      self.answers = answer_array
    end 
  end

  def update_default_answers
    if ["agree_equals_positive", "agree_equals_negitive"].include?(self.question_type)
      answer_array = self.default_answer_params.map do |params|
        Answer.new(params)
      end
      self.answers = answer_array
      self.answers.each(&:save)
    end 
  end

  def default_answer_params
    if self.question_type == "agree_equals_positive"
      [{contents: 'Strongly Agree',value:  2},
      {contents: 'Agree', value: 1},
      {contents: 'Neutral', value: 0},
      {contents: 'Disagree', value: -1},
      {contents: 'Strongly Disagree', value: -2}]
    elsif self.question_type == "agree_equals_negitive"
      [{contents: 'Strongly Agree',value: -2},
      {contents: 'Agree', value: -1},
      {contents: 'Neutral', value: 0},
      {contents: 'Disagree', value: 1},
      {contents: 'Strongly Disagree', value: 2}]
    end
  end
end
