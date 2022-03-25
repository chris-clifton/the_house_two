# frozen_string_literal: true

# This comes from:
# https://dev.to/kolide/a-rails-multi-tenant-strategy-thats-30-lines-and-just-works-58cd

# Include this module on any model that has a crew_id, and is expected to belong
# to a crew
module CrewOwnable
  extend ActiveSupport::Concern

  included do
    # Crew is actually not optional, but we not do want
    # to generate a SELECT query to verify the crew is
    # there every time. We get this protection for free
    # because of the `Current.crew_or_raise!`
    # and also through FK constraints.
    belongs_to :crew, optional: true
    default_scope { where(crew: Current.crew_or_raise!) }
  end
end
