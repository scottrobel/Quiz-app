# frozen_string_literal: true

class CreateQuestionChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :question_choices do |t|
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
