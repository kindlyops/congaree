class TaskPolicy < ApplicationPolicy
  def update?
    scope.where(id: record.id).exists?
  end

  def show?
    false
  end

  def edit?
    show?
  end

  def permitted_attributes
    [:done]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(message: :user).where(users: { organization_id: account.organization.id })
    end
  end
end
