class AddResponseCountToQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :responses_count, :integer, default: 0
  end
end
