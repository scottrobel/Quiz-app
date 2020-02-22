class Question < ApplicationRecord
  enum question_type: [:free_text, :choose_one, :multiple_choice]
  belongs_to :quiz
end
