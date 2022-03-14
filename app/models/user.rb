# frozen_string_literal: true

# User class
class User < ApplicationRecord
  # Default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chores, through: :assigned_chores
  has_many :assigned_chores
  has_many :consequences

  has_one_attached :avatar

  has_person_name

  extend FriendlyId
  friendly_id :name, use: :slugged

  enum role: [:user, :moderator, :admin]

  # def rewards_attributes=(rewards_attributes)
  #   rewards_attributes.each do |i, reward_attributes|
  #     self.reward.build(reward_attributes)
  #   end
  # end

  # def consequences_attributes=(consequences_attributes)
  #   consequences_attributes.each do |i, consequence_attributes|
  #     self.consequence.build(consequence_attributes)
  #   end
  # end
end
