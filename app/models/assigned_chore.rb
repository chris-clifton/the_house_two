# frozen_string_literal: true

# AssignedChore class
class AssignedChore < ApplicationRecord
  belongs_to :user
  belongs_to :chore
  has_one :reward, dependent: :destroy
  has_one :consequence, dependent: :destroy

  accepts_nested_attributes_for :consequence
  accepts_nested_attributes_for :reward

  enum status: [:in_progress, :pending_review, :complete, :failed]
end
