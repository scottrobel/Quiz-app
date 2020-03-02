# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.string :contents
      t.integer :question_id, null: false, foreign_key: true
      t.timestamps
    end
  end
end
