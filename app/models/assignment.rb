# frozen_string_literal: true

# Assignment class
class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :task
  has_one :reward, dependent: :destroy
  has_one :consequence, dependent: :destroy

  accepts_nested_attributes_for :consequence
  accepts_nested_attributes_for :reward

  enum status: [:in_progress, :pending_review, :complete, :failed]
end
