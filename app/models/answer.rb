class Answer < ApplicationRecord
  has_many :question_choices
  has_many :questions, through: :question_choices, inverse_of: :choices
end
