# frozen_string_literal: true

module AssignedChoreInteractions
  # Parent class for all AssignedChore interactions
  class BaseAssignedChoreInteraction
    attr_accessor :error, :message, :assigned_chore

    class RequiredParametersMissing < StandardError
      def to_s
        "Required parameters are missing"
      end
    end

    def initialize(options)
      @assigned_chore = options[:assigned_chore]
    end

    # Was the interaction successful?
    #
    # @return[Boolean]
    def succeeded?
      error.blank?
    end

    # This is the workhorse method for the interactor classes.  It should call
    # the interactor's 'run' method (which should be the only public method)
    #
    # @return [Interactor]
    def self.run(*args)
      interactor = new(*args)
      interactor.run
      interactor
    end

    private_class_method :new
  end
end
