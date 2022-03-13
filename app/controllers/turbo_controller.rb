# frozen_string_literal: true

# Devise and Turbo don't get along out of the box, particularly with error
# messages so this is the fix to handle turbo streams
# https://gorails.com/episodes/devise-hotwire-turbo
class TurboController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(format: :html))
    
    rescue ActionView::MissingTemplate => error
      if get?
        raise error
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end 
