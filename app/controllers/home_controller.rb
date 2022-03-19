# frozen_string_literal: true

# Home Controller
class HomeController < ApplicationController
  def index
    @assignments  = current_user.open_tasks
    @consequences = current_user.consequences
    @challenges   = current_user.challenges
    @trainings    = current_user.trainings
    @milestones   = current_user.milestones
  end
end
