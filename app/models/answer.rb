# frozen_string_literal: true

class Answer < ApplicationRecord
  has_many :response_answers, dependent: :destroy
  has_many :responses, through: :response_answers
  belongs_to :question
end
