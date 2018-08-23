class CreateWritingExerciseStates < ActiveRecord::Migration
  def change
    create_table :writing_exercise_states do |t|
      t.string :title
      t.string :body
      t.boolean :submitted
      t.integer :writing_exercise_id

      t.timestamps null: false
    end
  end
end
