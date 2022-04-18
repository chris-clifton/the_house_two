# frozen_string_literal: true

# Get off my back Rubocop, we all know what this is
class ApplicationController < ActionController::Base
  include SetAuthenticatedMember
  include Pundit::Authorization

  before_action :authenticate_member!

  before_action :configure_permitted_paramters, if: :devise_controller?

  # TODO: Set this up so Devise doesnt cry about it every time and I can
  #       set authorization on every action.
  # Make sure we've authorized with every Pundit after every action
  # after_action :verify_authorized

  # When a member logs out, always take them to the login view
  def after_sign_out_path_for(_)
    new_member_session_path
  end

  # Pundit is going to call current_user in order to authorize whatever policy
  # but we are using members and not users so we need to override the pundit_user
  # Ref: https://github.com/varvet/pundit#customize-pundit-user
  #
  # @return [Member]
  def pundit_user
    Current.member
  end

  protected

  def configure_permitted_paramters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end
end
