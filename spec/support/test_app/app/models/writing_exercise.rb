# frozen_string_literal: true

class WritingExercise < ActiveRecord::Base
  include RailsEventSource::EventMachine

  has_many :events, class_name: 'WritingExerciseEvent'
  has_one :state, class_name: 'WritingExerciseState', required: true, dependent: :destroy

  def initial_state
    wes = WritingExerciseState.new
    wes.writing_exercise_id = self.id
    wes.title = ''
    wes.body = ''
    wes
  end

  def apply(cmd)
    if cmd[:field] == 'title' && cmd[:text]
      [{ field: 'title',
         text: cmd[:text] }]
    elsif cmd[:field] == 'body' && cmd[:text]
      [{ field: 'body',
         text: cmd[:text] }]
    elsif cmd[:reset]
      [{ field: 'title',
         text: '' },
       { field: 'body',
         text: '' }]
    elsif cmd[:submit]
      if state.title.strip.empty? || state.body.strip.empty?
        []
      else
        [{ submit: true }]
      end
    else
      raise ArgumentError, "Invalid command #{cmd}"
    end
  end

  def fold(local_state, evt)
    return local_state if local_state.submitted

    if evt[:field] == 'title'
      local_state.title = evt[:text]
    elsif evt[:field] == 'body'
      local_state.body = evt[:text]
    elsif evt[:submit]
      local_state.submitted = true
    end
    local_state
  end
end
