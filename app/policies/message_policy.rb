class MessagePolicy < ApplicationPolicy
  def create?
    return unless account.present?
    account.organization == record.organization
  end

  def new?
    create?
  end

  def permitted_attributes
    [:body]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:user).where(users: { organization_id: account.organization.id })
    end
  end
end
