# frozen_string_literal: true

# User class
class User < ApplicationRecord
  # Default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, through: :assignments
  has_many :assignments

  has_one_attached :avatar

  has_person_name

  extend FriendlyId
  friendly_id :name, use: :slugged

  enum role: [:user, :moderator, :admin]

  # Return a collection of all a user's assignments that have the status
  # of either :in_progress or :pending_review
  #
  # @return [Assignedtask collection]
  def open_tasks
    assignments.where(status: [:in_progress, :pending_review])
  end

  # Return the sum of all a user's assignments reward's values for all
  # open tasks (status is either :in_progress or :pending_review)
  #
  # @return [Integer]
  def available_rewards
    open_tasks.map { |assignment| assignment.reward }.inject(0, :+)
  end

  # Return the sum of all a user's assignments rewards values
  # where the status is :failed
  #
  # @return [Integer]
  def missed_rewards
    missed_assignments = assignments.where(status: :failed)
    missed_assignments.map { |assignment| assignment.reward }.inject(0, :+)
  end

  # TODO: Stubbing this for now
  def consequences
    []
  end

  # TODO: Stubbing this for now
  def challenges
    []
  end

  # TODO: Stubbing this out for now
  def trainings
    []
  end

  # TODO: Stubbing this out for now
  def milestones
    []
  end
end
