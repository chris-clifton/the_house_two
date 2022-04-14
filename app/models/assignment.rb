# frozen_string_literal: true

# Assignment class
class Assignment < ApplicationRecord
  include AASM
  include CrewOwnable

  belongs_to :member
  belongs_to :task
  has_one :consequence, dependent: :destroy

  validates_presence_of :member_id, :task_id, :crew_id, :status

  accepts_nested_attributes_for :consequence

  enum status: [:in_progress, :pending_review, :complete, :failed]

  # Use a state machine to handle the transitions between an Assignment's statuses
  aasm :status, enum: true do
    state :in_progress, initial: true
    state :pending_review, :complete, :failed

    # Callback to update the Assignment anytime it's status has changed
    after_all_transitions :save_state

    # An Assignment in any state can be marked as :in_progress by a captain
    # and a member should be able to mark their assignment back to :in_progress
    # if it's current status is :pending_review (taken care of by Pundit)
    # Run the :update_in_progress callback after updating the status
    event :mark_in_progress, after: :update_in_progress do
      transitions from: [:pending_review], to: :in_progress

      transitions from: [:complete, :failed], to: :in_progress do
        guard do
          Pundit.policy(Current.member, self).mark_in_progress?
        end
      end
    end

    # An Assignment in any state can be marked as :pending_review by a captain
    # and a member should be able to make this change if it's current status
    # is :in_progress (taken care of by Pundit)
    event :mark_pending_review, after: :update_pending_review do
      transitions from: [:in_progress, :complete, :failed], to: :pending_review do
        guard do
          Pundit.policy(Current.member, self).mark_pending_review?
        end
      end
    end

    # An Assignment in any state can be marked :complete by a captain
    # Run the :update_complete callback after updating the status
    event :mark_complete, after: :update_complete do
      transitions from: [:pending_review, :in_progress, :failed], to: :complete do
        guard do
          Pundit.policy(Current.member, self).mark_complete?
        end
      end
    end

    # An Assignment in any state can be marked :failed by a captain
    # Run the :update_failed callback after updating the status
    event :mark_failed, after: :update_failed do
      transitions from: [:in_progress, :pending_review, :complete], to: :failed do
        guard do
          Pundit.policy(Current.member, self).mark_failed?
        end
      end
    end
  end

  private

  # Callback for the state machine's transition to :complete
  def update_complete
    AssignmentInteractions::UpdateComplete.run(assignment: self, member: Current.member)
  end

  # Callback for the state machine's transition to :failed
  def update_failed
    AssignmentInteractions::UpdateFailed.run(assignment: self, member: Current.member)
  end

  # Callback for the state machine's transition to :in_progress
  def update_in_progress
    AssignmentInteractions::UpdateInProgress.run(assignment: self, member: Current.member)
  end

  # Callback for the state machine's transition to :pending_review
  def update_pending_review
    AssignmentInteractions::UpdatePendingReview.run(assignment: self, member: Current.member)
  end

  # Callback for any of our state machine's transitions to ensure we always save
  # the record with the updated status
  def save_state
    self.update(status: aasm(:status).to_state)
  end
end
