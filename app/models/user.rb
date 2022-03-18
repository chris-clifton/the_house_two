# frozen_string_literal: true

# User class
class User < ApplicationRecord
  # Default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chores, through: :assigned_chores
  has_many :assigned_chores

  has_one_attached :avatar

  has_person_name

  extend FriendlyId
  friendly_id :name, use: :slugged

  enum role: [:user, :moderator, :admin]

  # Return a collection of all a user's assigned chores that have the status
  # of either :in_progress or :pending_review
  #
  # @return [AssignedChore collection]
  def open_chores
    assigned_chores.where(status: [:in_progress, :pending_review])
  end

  # Return the sum of all a user's assigned chores reward's values for all
  # open chores (status is either :in_progress or :pending_review)
  #
  # @return [Integer]
  def available_rewards
    open_chores.map { |ac| ac.reward.value }.inject(0, :+)
  end

  # Return the sum of all a user's assigned_chores rewards values
  # where the status is :failed
  #
  # @return [Integer]
  def missed_rewards
    missed_chores = assigned_chores.where(status: :failed)
    missed_chores.map { |ac| ac.reward.value }.inject(0, :+)
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
