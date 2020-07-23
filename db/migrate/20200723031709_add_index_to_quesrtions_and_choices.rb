class AddIndexToQuesrtionsAndChoices < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :index, :integer
    add_column :answers, :index, :integer
  end
end
