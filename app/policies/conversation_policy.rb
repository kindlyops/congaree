# frozen_string_literal: true
class ConversationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.conversations
    end
  end
end
