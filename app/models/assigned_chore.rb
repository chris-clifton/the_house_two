# frozen_string_literal: true

# AssignedChore class
class AssignedChore < ApplicationRecord
  belongs_to :user
  belongs_to :chore
  has_one :consequence, through: :assigned_chore_consequences

  accepts_nested_attributes_for :consequence
end
