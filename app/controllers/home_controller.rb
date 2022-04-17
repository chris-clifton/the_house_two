# frozen_string_literal: true

# Home Controller
class HomeController < ApplicationController
  def index
    @assignments  = current_member.open_assignments
    @consequences = current_member.consequences
    @challenges   = current_member.challenges
    @trainings    = current_member.trainings
    @milestones   = current_member.milestones
  end
end
