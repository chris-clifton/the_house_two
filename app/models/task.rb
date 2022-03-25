# frozen_string_literal: true

# Task class
class Task < ApplicationRecord
  include CrewOwnable

  has_many :assignments, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # TODO: Should training be a type of Task?
  #       Should we use STI here instead?
  enum category: [:chore, :challenge]

  # Return an array of (uniq) members assigned to a task
  #
  # @return [Array]
  def currently_assigned_members
    assignments.map(&:member).uniq
  end
end
