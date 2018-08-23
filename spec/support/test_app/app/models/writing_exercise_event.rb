class WritingExerciseEvent < ActiveRecord::Base
  belongs_to :machine, class_name: WritingExercise, inverse_of: :events
end
