# frozen_string_literal: true

class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.belongs_to :quiz
      t.belongs_to :user
      t.timestamps
    end
    add_index :responses, %i[quiz_id user_id], unique: true
  end
end
