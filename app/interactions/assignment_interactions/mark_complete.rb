# frozen_string_literal: true

module AssignmentInteractions
  class MarkComplete < BaseAssignmentInteraction
    def initialize(options)
      super
      @user = options[:user]
    end

    # This should be the only public method for this interactor
    def run
      check_required_parameters

      @assignment.update(status: :pending_review)

      self.message = 'This task has been marked complete and awaiting approval'
    rescue StandardError => e
      self.message = 'Error updating the status of this task'
      self.error   = e
    end

    private

    def check_required_parameters
      raise RequiredParametersMissing unless @user.present? && @assignment.present?
    end

    def log_changes(message)
      Rails.logger.info "AssignmentInteractions::MarkComplete - Assignment: #{@assignment.id}, User: #{@user.id} - #{message}"
    end
  end
end
