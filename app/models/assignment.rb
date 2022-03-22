# frozen_string_literal: true

# Assignment class
class Assignment < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :task
  has_one :consequence, dependent: :destroy

  accepts_nested_attributes_for :consequence

  enum status: [:in_progress, :pending_review, :complete, :failed]

  # Use a state machine to handle the transitions between an Assignment's statuses
  aasm column: :status, enum: true do
    state :in_progress, initial: true
    state :pending_review, :complete, :failed

    # Callback to update the Assignment anytime it's status has changed
    after_all_transitions :save_state

    # An Assignment in any state can be marked as in_progress by an admin
    # Run the :update_task_as_in_progress callback after updating the status
    # TODO: allow an optional note to be passed in, and then call an interactor
    #       passing arguments: https://github.com/aasm/aasm/issues/506
    event :mark_in_progress, after: :update_task_as_in_progress do
      transitions from: [:pending_review, :complete, :failed], to: :in_progress
    end

    # An Assignment in the state :in_progress can only be changed to
    # :pending_review by a user
    # TODO: Right now we dont need any kind of callback here, but eventually
    #       we'll want to notify admins that there are some assignments to review
    # TODO: allow an optional note to be passed in, and then call an interactor
    #       passing arguments: https://github.com/aasm/aasm/issues/506
    event :mark_pending_review do
      transitions from: [:in_progress, :complete, :failed], to: :pending_review
    end

    # An Assignment in any state can be marked :complete by an admin
    # Run the :update_task_as_complete callback after updating the status
    # TODO: allow an optional note to be passed in, and then call an interactor
    #       passing arguments: https://github.com/aasm/aasm/issues/506
    event :mark_complete, after: :update_task_as_complete do
      transitions from: [:pending_review, :in_progress, :failed], to: :complete
    end

    # An Assignment in any state can be marked :failed by an admin
    # Run the :update_task_as_failed callback after updating the status
    # TODO: allow an optional note to be passed in, and then call an interactor
    #       passing arguments: https://github.com/aasm/aasm/issues/506
    event :mark_failed, after: :update_task_as_failed do
      transitions from: [:in_progress, :pending_review, :complete], to: :failed
    end
  end

  private

  # Callback for the state machine's transition to :complete
  # We need to apply the Assignment's reward to the user's reward_balance
  # and flip the reward_applied boolean to true.
  def update_task_as_complete
    AssignmentInteractions::MarkComplete.run(assignment: self)

    # if reward_applied?
    #   # Scenarios to get here: a bug
    #   # How can the reward still have been applied? Something must not be right
    #   # in one of the other state machine callbacks or there is some other issue.
    #   # Leaving a pry here in case this ever comes up and there might be more
    #   # context in the moment
    #   #
    #   # user.update(rewards_balance: user.rewards_balance - reward)
    #   # update(reward_applied: false)
    #   binding.pry
    # else
    #   user.update(rewards_balance: user.rewards_balance + reward)
    #   update(reward_applied: true)
    # end
  end

  # Callback for the state machine's transition to :failed
  # If we've already appied the reward, then we need to roll that back and also
  # flip the reward_applied boolean back to false
  def update_task_as_failed
    if reward_applied?
      user.update(rewards_balance: user.rewards_balance - reward)
      update(reward_applied: false)
    else
      # Scenarios to get here: task was in progress but someone else had to do it
      # i.e. feed the dog breakfast. What should happen here? I dont think we need
      # to worry about applying/deducting rewards but maybe should check to make sure.
      # Possibly just want to apply some consequences? Leaving a pry in case I end up here
      # and have a better idea and can leave better comments
      binding.pry
    end
  end

  # Callback for the state machine's transition to :in_progress
  # If we have already applied the reward for completing this task but we need
  # to change its status back to :in_progress, we need to rollback the reward
  # and flip the reward_applied boolean back to false.
  def update_task_as_in_progress
    return unless reward_applied?

    user.update(rewards_balance: user.rewards_balance - reward)
    update(reward_applied: false)
  end

  # Callback for any of our state machine's transitions to ensure we always save
  # the record with the updated status
  def save_state 
    self.update(status: aasm.to_state) 
  end
end
