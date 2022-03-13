# frozen_string_literal: true

# Chore class
class Chore < ApplicationRecord
  has_many :assigned_chores, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
