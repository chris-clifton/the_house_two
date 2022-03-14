# frozen_string_literal: true

# Chore class
class Chore < ApplicationRecord
  has_many :assigned_chores, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Return an array of (uniq) users assigned to a chore
  #
  # @return [Array]
  def currently_assigned_users
    assigned_chores.map(&:user).uniq
  end
end
