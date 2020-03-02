# frozen_string_literal: true

class Quiz < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions
  has_many :responses, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true
end
