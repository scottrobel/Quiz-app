class Question < ApplicationRecord
  enum question_type: [:open_ended, :select_one, :multiple_choice]
  belongs_to :quiz
  has_many :question_choices
  has_many :choices, through: :question_choices, source: 'answer', inverse_of: :question, dependent: :destroy
  has_many :question_answers
  has_many :answers, through: :question_answers, inverse_of: :question
  has_many :responses, through: :quiz
  accepts_nested_attributes_for :choices, :allow_destroy => true
  accepts_nested_attributes_for :answers
end
