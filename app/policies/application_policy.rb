# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :member, :record

  def initialize(member, record)
    @member = member
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(member, scope)
      @member = member
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :member, :scope
  end
end
