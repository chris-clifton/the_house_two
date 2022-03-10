# frozen_string_literal: true

# User class
class User < ApplicationRecord
  # Default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chores, through: :assigned_chores
  has_many :assigned_chores
  has_many :consequences

  enum role: [:user, :moderator, :admin]
end
