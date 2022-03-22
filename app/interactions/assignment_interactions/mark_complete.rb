# frozen_string_literal: true

# TODO: Document
module AssignmentInteractions
  # Class to handle assigning alert dispositions to Assignments in bulk
  class MarkComplete < BaseAssignmentInteraction
    def initialize(options)
      super
    end

    def run
      binding.pry
    rescue StandardError => e
      binding.pry
    end
  end
end
