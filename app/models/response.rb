class Response < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :response_answers
  has_many :answers, through: :response_answers
end
