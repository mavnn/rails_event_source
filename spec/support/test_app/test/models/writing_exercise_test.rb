require 'rails_helper'

class WritingExerciseTest < ActiveSupport::TestCase
  test 'can update stuff' do
    we = WritingExercise.create
    we.process_command(field: 'title', text: 'my title')
    assert_equal 'my title', we.state.title
  end
end
