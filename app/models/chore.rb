# frozen_string_literal: true

# Chore class
class Chore < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
