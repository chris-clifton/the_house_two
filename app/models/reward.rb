# frozen_string_literal: true

# Reward class
class Reward < ApplicationRecord
  enum category: [:reward_points, :screen_time]
end
