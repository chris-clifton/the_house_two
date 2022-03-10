# frozen_string_literal: true

# Get off my back Rubocop, we all know what this is
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # TODO: Set this up so Devise doesnt cry about it every time and I can
  #       set authorization on every action.
  # Make sure we've authorized with every Pundit after every action
  # after_action :verify_authorized

  # When a user logs out, always take them to the login view
  def after_sign_out_path_for(_)
    new_user_session_path
  end
end
