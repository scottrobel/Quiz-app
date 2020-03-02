# frozen_string_literal: true

class ResponseAnswer < ApplicationRecord
  belongs_to :response
  belongs_to :answer
end
