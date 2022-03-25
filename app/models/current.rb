# frozen_string_literal: true

# This comes from: https://dev.to/kolide/a-rails-multi-tenant-strategy-thats-30-lines-and-just-works-58cd

class Current < ActiveSupport::CurrentAttributes
  attribute :crew, :member

  resets { Time.zone = nil }

  class MissingCurrentCrew < StandardError; end

  def crew_or_raise!
    raise Current::MissingCurrentCrew, "You must set a crew with Current.crew=" unless crew

    crew
  end

  def member=(member)
    super
    self.crew = member.crew
    # We likely want to track a users time zone so we can track task expiration
    # in their time zones.
    # Time.zone = member.time_zone
  end
end
