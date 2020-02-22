class Question < ApplicationRecord
  enum question_type: [:open_ended, :select_one, :multiple_choice]
  belongs_to :quiz
end
