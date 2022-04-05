# frozen_string_literal: true

# When an Assignment is marked as pending review, we need to check to see if the
# assignment was in a state where the reward had already been applied and, if so,
# roll that back.
# Rescue any errors, and always log what we did here.
# TODO: Eventually we will also want to rollback any consequences that may have
#       been applied as a result of this Assignment having been marked failed. 
module AssignmentInteractions
  # Class to handle logic after an Assignment has been updated to :pending_review
  class UpdatePendingReview < BaseAssignmentInteraction
    # This should be the only public method in the interaction
    def run
      if @assignment.reward_applied?
        rollback_rewards
        log_changes("Marked Pending Review - existing rewards were rolled back")
      else
        log_changes("Marked Pending Review")
      end
    rescue StandardError => e
      log_changes("Error - #{e}, Backtrace: #{e.backtrace}")
    end

    private

    # Log changes specific to this interactor
    #
    # @param message [String]
    def log_changes(message)
      Rails.logger.info "AssignmentInteractions::UpdatePendingReview - Assignment: #{@assignment.id}, Member: #{@member.id} - #{message}"
    end   
  end
end
