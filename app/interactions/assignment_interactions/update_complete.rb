# frozen_string_literal: true

# When an assignment is marked as complete (which only a Captain should be able
# to do), we should apply the Assignment's rewards to the member.
# We also need to check to see if the assignment was in a state where the reward
# had already been applied. If so, something is horribly wrong and we want to
# raise an error so we can track that down.
# Rescue any errors, and always log what we did here.
module AssignmentInteractions
  # Class to handle logic after an Assignment has been updated to :complete
  class UpdateComplete < BaseAssignmentInteraction
    def initialize(options)
      super
    end

    # This should be the only public method in the interaction
    def run
      # TODO: Use pundit authorization and raise a pundit error
      # Only a captain should be able to mark an Assignment complete
      raise StandardError unless @member.captain?

      if @assignment.reward_applied?
        # How can the reward have been applied already but we are trying to apply it again now?
        # Something must not be right in one of the other state machine callbacks or there is some other issue.
        raise StandardError.new "Tried to mark this assignment complete and the rewards had already been applied somehow"
      else
        apply_rewards
        log_changes("Marked Complete - rewards applied")
      end
    rescue StandardError => e
      log_changes("Error - #{e}, Backtrace: #{e.backtrace}")
    end

    private

    # Log changes specific to this interactor
    #
    # @param message [String]
    def log_changes(message)
      Rails.logger.info "AssignmentInteractions::UpdateComplete - Assignment: #{@assignment.id}, Member: #{@member.id} - #{message}"
    end
  end
end
