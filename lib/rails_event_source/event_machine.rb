# frozen_string_literal: true

require 'active_support/concern'
require 'active_record'

module RailsEventSource
  module EventMachine
    extend ActiveSupport::Concern

    included do
      unless ancestors.include?(ActiveRecord::Base)
        raise ArgumentError, 'You should only include RailsEventSource::EventMachine in a child of ActiveRecord::Base'
      end
      after_initialize :init
    end

    def init
      self.state ||= initial_state
    end

    def process_command(command)
      transaction do
        state.reload(lock: true)
        new_events = apply(command)
        unless new_events.empty?
          self.state = new_events.inject(state) { |current, evt| fold(current, evt) }
          new_events.tap { |evt| events.create!(evt) }
          state.save!
        end
      end
    end

    def load_at_time(datetime)
      clean_state = initial_state
      clean_state.save
      evts = events.where('created_at < ?', datetime)
      evts.inject(clean_state) { |current, evt| fold(current, evt) }
    end

    def load_at_event(count)
      clean_state = initial_state
      evts = events.first count
      evts.inject(clean_state) { |current, evt| fold(current, evt) }
    end
  end
end
