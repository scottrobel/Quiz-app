# frozen_string_literal: true

class Question < ApplicationRecord
  enum question_type: %i[open_ended select_one multiple_choice]
  belongs_to :quiz
  has_many :responses, through: :quiz
  has_many :questions
  accepts_nested_attributes_for :answers
 end
