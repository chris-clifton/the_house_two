# frozen_string_literal: true

# When an Assignment is marked as failed (which only a Captain should be able to
# do), we need to check to see if the assignment was in a state where the reward
# had already been applied and, if so, roll that back.
# Rescue any errors, and always log what we did here.
module AssignmentInteractions
  # Class to handle logic after an Assignment has been updated to :failed
  class UpdateFailed < BaseAssignmentInteraction
    def initialize(options)
      super
    end

    # This should be the only public method in the interaction
    def run
      # TODO: Use pundit authorization and raise a pundit error
      # Only a captain should be able to mark an Assignment failed
      raise StandardError unless @member.captain?

      if @assignment.reward_applied?
        rollback_rewards
        log_changes("Marked Failed - existing rewards were rolled back")
      else
        # TODO: Besides assigning the consequence to the member, what else do
        #       we want to do here?
        log_changes("Marked Failed")
      end
    rescue StandardError => e
      log_changes("Error - #{e}, Backtrace: #{e.backtrace}")
    end

    private

    # Log changes specific to this interactor
    #
    # @param message [String]
    def log_changes(message)
      Rails.logger.info "AssignmentInteractions::UpdateFailed - Assignment: #{@assignment.id}, Member: #{@member.id} - #{message}"
    end
  end
end
