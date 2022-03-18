# frozen_string_literal: true

# Home Controller
class HomeController < ApplicationController
  def index
    @assigned_chores = current_user.open_chores
    @consequences = current_user.consequences
    @challenges = current_user.challenges
    @trainings = current_user.trainings
    @milestones = current_user.milestones
  end
end
