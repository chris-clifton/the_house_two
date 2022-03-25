# frozen_string_literal: true

# This comes from: https://dev.to/kolide/a-rails-multi-tenant-strategy-thats-30-lines-and-just-works-58cd

module App
  module Console
    def t(id)
      Current.crew = Crew.find(id)
      puts "Current crew switched to #{Current.crew.name} (#{Current.crew.id})"
    end
  end
end
