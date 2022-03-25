# frozen_string_literal: true

# Crew class
class Crew < ApplicationRecord
  extend FriendlyId

  has_many :members, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  friendly_id :name, use: :slugged
end
