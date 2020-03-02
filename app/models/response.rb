# frozen_string_literal: true

class Response < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :response_answers, dependent: :destroy
  has_many :answers, through: :response_answers, inverse_of: :responses, dependent: :destroy
end
