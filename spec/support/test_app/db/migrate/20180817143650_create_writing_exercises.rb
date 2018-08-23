class CreateWritingExercises < ActiveRecord::Migration
  def change
    create_table :writing_exercises do |t|
      t.timestamps null: false
    end
  end
end
