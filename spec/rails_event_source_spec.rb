require "rails_helper"
require "Timecop"

RSpec.describe RailsEventSource do
  it 'has a version number' do
    expect(RailsEventSource::VERSION).not_to be nil
  end

  it 'can create a event machine' do
    writing_exercise = WritingExercise.create
    expect(writing_exercise).to respond_to(:state)
    expect(writing_exercise).to respond_to(:events)
    expect(writing_exercise).to respond_to(:process_command)
  end

  it 'can add an event to an event machine' do
    writing_exercise = WritingExercise.create
    writing_exercise.process_command(field: 'title', text: 'My title')
    expect(writing_exercise.state.title).to eq('My title')
  end

  it 'can add events to an event machine' do
    writing_exercise = WritingExercise.create
    writing_exercise.process_command(field: 'title', text: 'My title')
    writing_exercise.process_command(field: 'body', text: 'My writing here')
    writing_exercise.process_command(field: 'title', text: 'My title 2')
    expect(writing_exercise.state.title).to eq('My title 2')
    expect(writing_exercise.state.body).to eq('My writing here')
  end

  it 'can deal with multiple events from a single command' do
    writing_exercise = WritingExercise.create
    writing_exercise.process_command(field: 'title', text: 'My title')
    writing_exercise.process_command(field: 'body', text: 'My writing here')
    writing_exercise.process_command(reset: true)
    expect(writing_exercise.state.title).to eq('')
    expect(writing_exercise.state.body).to eq('')
  end

  it 'can load events up to a count' do
    writing_exercise = WritingExercise.create
    writing_exercise.process_command(field: 'title', text: 'My title')
    writing_exercise.process_command(field: 'title', text: 'My title 2')
    state_at_one = writing_exercise.load_at_event 1
    expect(state_at_one.title).to eq('My title')
  end

  it 'can load events up to a certain time' do
    writing_exercise = WritingExercise.create
    Timecop.freeze(DateTime.new(2018, 1, 1, 1, 1, 1)) do
      writing_exercise.process_command(field: 'title', text: 'My title')
    end

    Timecop.freeze(DateTime.new(2018, 1, 2, 1, 1, 1)) do
      writing_exercise.process_command(field: 'title', text: 'My title 2')
    end
    state_at_one = writing_exercise.load_at_time(DateTime.new(2018, 1, 1, 2, 1, 1))
    expect(state_at_one.title).to eq('My title')
  end

  it 'can ignore commands that produce no events' do
    writing_exercise = WritingExercise.create
    writing_exercise.process_command(field: 'title', text: 'My title')
    writing_exercise.process_command(field: 'body', text: 'My writing here')
    writing_exercise.process_command(submit: true)
    writing_exercise.process_command(field: 'title', text: 'My title 2')
    expect(writing_exercise.state.title).to eq('My title')
    expect(writing_exercise.state.submitted).to eq(true)
  end
end
