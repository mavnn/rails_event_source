class CreateWritingExerciseEvents < ActiveRecord::Migration
  def change
    create_table :writing_exercise_events do |t|
      t.string :field
      t.string :text
      t.boolean :reset
      t.boolean :submit

      t.integer :writing_exercise_id

      t.timestamps null: false
    end
  end
end
