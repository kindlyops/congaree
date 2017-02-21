class ConversationPolicy < ApplicationPolicy
  def scope
    Subscriber
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
