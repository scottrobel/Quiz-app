class Quiz < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :questions
  accepts_nested_attributes_for :questions, :allow_destroy => true
end
