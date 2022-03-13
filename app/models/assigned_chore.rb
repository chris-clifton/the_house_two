# frozen_string_literal: true

# AssignedChore class
class AssignedChore < ApplicationRecord
  belongs_to :user
  belongs_to :chore
  has_one :reward, dependent: :destroy
  has_one :consequence, dependent: :destroy

  accepts_nested_attributes_for :consequence
  accepts_nested_attributes_for :reward

  # TODO: change the "complete" and "failed" columns to a single column named "status"
  #       The new status column should be an enum with the following options:
  #       complete, failed, pending (user marked done but needs admin approval)
end
