# frozen_string_literal: true

# Task class
class Task < ApplicationRecord
  has_many :assignments, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # TODO: Should training be a type of Task?
  #       Should we use STI here instead?
  enum category: [:chore, :challenge]

  # Return an array of (uniq) users assigned to a task
  #
  # @return [Array]
  def currently_assigned_users
    assignments.map(&:user).uniq
  end
end
