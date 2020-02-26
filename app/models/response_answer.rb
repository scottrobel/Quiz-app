class ResponseAnswer < ApplicationRecord
  belongs_to :response
  belongs_to :answer
  has_many :question_answers, through: :answer
end
