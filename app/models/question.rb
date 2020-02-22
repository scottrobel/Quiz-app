class Question < ApplicationRecord
  enum question_type: [:free_text, :choose_one, :choose_multiple]
  belongs_to :quiz
end
