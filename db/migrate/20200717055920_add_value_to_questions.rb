class AddValueToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :value, :integer
    add_column :questions, :axis, :text
  end
end
