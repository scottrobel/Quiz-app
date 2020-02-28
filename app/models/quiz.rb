# frozen_string_literal: true

class Quiz < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :questions
  has_many :question_answers, through: :questions
  has_many :responses
  accepts_nested_attributes_for :questions, allow_destroy: true
end
