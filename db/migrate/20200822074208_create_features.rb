class CreateFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :features do |t|
      t.integer :quiz_id, index: true
      t.timestamps
    end
  end
end
