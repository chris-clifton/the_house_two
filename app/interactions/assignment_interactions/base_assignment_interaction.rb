# frozen_string_literal: true

module AssignmentInteractions
  # Parent class for all Assignment interactions
  class BaseAssignmentInteraction
    attr_accessor :error, :message, :assignment

    class RequiredParametersMissing < StandardError
      def to_s
        "Required parameters are missing"
      end
    end

    def initialize(options)
      @assignment = options[:assignment]
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
