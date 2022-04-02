# frozen_string_literal: true

# Assignment class
class Assignment < ApplicationRecord
  include AASM
  include CrewOwnable

  belongs_to :member
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

    # An Assignment in any state can be marked as in_progress by a member
    # Run the :update_task_as_in_progress callback after updating the status
    event :mark_in_progress, :after => Proc.new { |member| update_task_as_in_progress(member) } do
      transitions from: [:pending_review, :complete, :failed], to: :in_progress
    end

    # An Assignment in the state :in_progress can only be changed to
    # :pending_review by a member
    event :mark_pending_review, :after => Proc.new { |member| update_task_as_pending_review(member) } do
      transitions from: [:in_progress, :complete, :failed], to: :pending_review
    end

    # An Assignment in any state can be marked :complete by a captain
    # Run the :update_task_as_complete callback after updating the status
    event :mark_complete, :after => Proc.new { |member| update_task_as_complete(member) } do
      transitions from: [:pending_review, :in_progress, :failed], to: :complete
    end

    # An Assignment in any state can be marked :failed by a captain
    # Run the :update_task_as_failed callback after updating the status
    event :mark_failed, :after => Proc.new { |member| update_task_as_failed(member) } do
      transitions from: [:in_progress, :pending_review, :complete], to: :failed
    end
  end

  private

  # Callback for the state machine's transition to :complete
  #
  # @param member [Member]
  def update_task_as_complete(member)
    AssignmentInteractions::UpdateComplete.run(assignment: self, member: member)
  end

  # Callback for the state machine's transition to :failed
  #
  # @param member [Member]
  def update_task_as_failed(member)
    AssignmentInteractions::UpdateFailed.run(assignment: self, member: member)
  end

  # Callback for the state machine's transition to :in_progress
  #
  # @param member [Member]
  def update_task_as_in_progress(member)
    AssignmentInteractions::UpdateInProgress.run(assignment: self, member: member)
  end

  # Callback for the state machine's transition to :pending_review
  #
  # @param member [Member]
  def update_task_as_pending_review(member)
    AssignmentInteractions::UpdatePendingReview.run(assignment: self, member: member)
  end

  # Callback for any of our state machine's transitions to ensure we always save
  # the record with the updated status
  def save_state
    self.update(status: aasm.to_state)
  end
end
