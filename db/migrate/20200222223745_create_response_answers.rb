# frozen_string_literal: true

class CreateResponseAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :response_answers do |t|
      t.belongs_to :response, null: false, foreign_key: true
      t.belongs_to :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
