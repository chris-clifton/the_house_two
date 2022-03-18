# frozen_string_literal: true

module AssignedChoreInteractions
  class MarkComplete < BaseAssignedChoreInteraction
    def initialize(options)
      super
      @user = options[:user]
    end

    # This should be the only public method for this interactor
    def run
      check_required_parameters

      @assigned_chore.update(status: :pending_review)

      self.message = 'This chore has been marked complete and awaiting approval'
    rescue StandardError => e
      self.message = 'Error updating the status of this chore'
      self.error   = e
    end

    private

    def check_required_parameters
      raise RequiredParametersMissing unless @user.present? && @assigned_chore.present?
    end

    def log_changes(message)
      Rails.logger.info "AssignedChoreInteractions::UpdateStatus - AssignedChore: #{@assigned_chore.id}, User: #{@user.id} - #{message}"
    end
  end
end
