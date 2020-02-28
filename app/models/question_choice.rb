# frozen_string_literal: true

class QuestionChoice < ApplicationRecord
  belongs_to :question
  belongs_to :answer
end
