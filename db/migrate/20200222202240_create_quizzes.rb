# frozen_string_literal: true

class CreateQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :quizzes do |t|
      t.belongs_to :creator
      t.string :title

      t.timestamps
    end
  end
end
