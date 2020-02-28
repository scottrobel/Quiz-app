# frozen_string_literal: true

class Answer < ApplicationRecord
  has_one :question_choice
  has_many :question_answers
  has_many :answers_of, class_name: 'Question', through: :question_answers, source: :question
  has_one :question, through: :question_choice, inverse_of: :choices
  has_many :response_answers, dependent: :destroy
  has_many :responses, through: :response_answers
  validates :contents, presence: true
end
