class AddTopBottomLabels < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :top_label, :text
    add_column :quizzes, :bottom_label, :text
    add_column :quizzes, :right_label, :text
    add_column :quizzes, :left_label, :text
  end
end
