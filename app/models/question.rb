# frozen_string_literal: true

class Question < ApplicationRecord
  enum question_type: %i[open_ended drop_down check_boxes]
  belongs_to :quiz
  has_many :responses, through: :quiz
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true
 end
