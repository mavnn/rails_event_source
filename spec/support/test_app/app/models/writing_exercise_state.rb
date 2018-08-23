class WritingExerciseState < ActiveRecord::Base
  belongs_to :machine, class_name: WritingExercise, inverse_of: :state
end
