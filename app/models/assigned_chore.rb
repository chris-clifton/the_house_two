# frozen_string_literal: true

# AssignedChore class
class AssignedChore < ApplicationRecord
  belongs_to :user
  has_one :chore
  has_one :reward
  has_one :consequence

  accepts_nested_attributes_for :consequence
  accepts_nested_attributes_for :reward
end
