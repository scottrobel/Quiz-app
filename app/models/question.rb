class Question < ApplicationRecord
  enum question_type: [:open_ended, :select_one, :multiple_choice]
  belongs_to :quiz
  has_many :question_choices
  has_many :choices, through: :question_choices, source: 'answer', inverse_of: :questions
  accepts_nested_attributes_for :choices, :allow_destroy => true
end
