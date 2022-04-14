# frozen_string_literal: true

# Class to handle authorization via Pundit policies on Assignments
class AssignmentPolicy < ApplicationPolicy
  # Only captains should be able to create an assignment
  #
  # @return [Boolean]  
  def create?
    @member.captain?
  end

  # Only captains should be able to create an assignment
  #
  # @return [Boolean]
  def new?
    create?
  end

  # Only captains should be able to update an assignment
  #
  # @return [Boolean]
  def update?
    @member.captain?
  end

  # Only captains should be able to update an assignment
  #
  # @return [Boolean]
  def edit?
    update?
  end

  # Only captains should be able to destroy an assignment
  #
  # @return [Boolean]
  def destroy?
    @member.captain?
  end

  # If the member is a captain, they should be able to update an assignment's
  # status to :pending review regardless of it's current status and who the
  # assignment belongs to. If the member is a member, they should only be
  # able to mark an assignment as :pending_review if its current status is
  # :in_progress and the assignment belongs to them.
  #
  # @return [Boolean]
  def mark_pending_review?
    return true if @member.captain?

    @record.member_id == @member.id && @record.in_progress?
  end

  # If the member is a captain, they should be able to update an assignment's
  # status to :in_progress regardless of it's current status and who the assignment
  # belongs to. If the member is a member, they should only be able to mark an
  # assignment as :in_progress if its current status is :pending_review and the
  # assignment belongs to them.
  #
  # @return [Boolean]
  def mark_in_progress?
    return true if @member.captain?

    @record.member_id == @member.id && @record.pending_review?
  end

  # Only captains should be able to mark an assignment complete
  #
  # @return [Boolean]
  def mark_complete?
    @member.captain?
  end

  # Only captains should be able to mark an assignment failed
  #
  # @return [Boolean]
  def mark_failed?
    @member.captain?
  end
end
