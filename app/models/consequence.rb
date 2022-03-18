# frozen_string_literal: true

# Consequence class
class Consequence < ApplicationRecord
  enum duration: [:minutes, :hours, :days, :weeks]
  enum category: [:screen_time, :time_out]

  def pretty_consequence
    "#{value} #{duration} #{category.humanize}"
  end 
end
