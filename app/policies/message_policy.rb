class MessagePolicy < ApplicationPolicy
  def create?
    recipient.actively_subscribed_to?(account.teams)
  end

  delegate :recipient, to: :record

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(conversation: organization.conversations)
    end
  end
end
