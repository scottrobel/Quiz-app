class RemoveIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :responses, name: "index_responses_on_quiz_id_and_user_id"
  end
end
