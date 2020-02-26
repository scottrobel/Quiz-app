class Answer < ApplicationRecord
  has_one :question_choice
  has_many :question_answers
  has_one :question, through: :question_choice, inverse_of: :choices
  has_many :response_answers
  has_many :responses, through: :response_answers
end
