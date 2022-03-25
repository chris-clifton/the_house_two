# frozen_string_literal: true

# This comes from: https://dev.to/kolide/a-rails-multi-tenant-strategy-thats-30-lines-and-just-works-58cd

module SetAuthenticatedMember
  extend ActiveSupport::Concern

  included do
    before_action :set_authenticated_member
  end

  def set_authenticated_member
    Current.member = current_member if current_member
  end
end
