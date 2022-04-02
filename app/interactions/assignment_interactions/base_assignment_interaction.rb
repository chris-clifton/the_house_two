# frozen_string_literal: true

module AssignmentInteractions
  # Parent class for all Assignment interactions
  class BaseAssignmentInteraction

    # Custom class to handle the case where any of our parameters arent correct
    class RequiredParametersMissing < StandardError
      # Message for the error
      def to_s
        'Required parameters are missing'
      end
    end

    def initialize(options)
      @assignment = options[:assignment]
      @member     = options[:member]
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

    private

    # Subtract the assignment's reward value from the member's rewards_balance
    # and set the assignment's reward_applied value to false
    def rollback_rewards
      @assignment.member.update(rewards_balance: @assignment.member.rewards_balance - @assignment.reward)
      @assignment.update(reward_applied: false)
    end

    # Add the assignment's reward value to the member's rewards_balance
    # and set the assignment's reward_applied value to true
    def apply_rewards
      @assignment.member.update(rewards_balance: @assignment.member.rewards_balance + @assignment.reward)
      @assignment.update(reward_applied: true)
    end
  end
end
