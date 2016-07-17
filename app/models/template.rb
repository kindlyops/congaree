class Template < ApplicationRecord
  belongs_to :organization
  has_many :notifications
  belongs_to :actionable, foreign_key: :actionable_id, class_name: "TemplateActionable"
  before_create :create_actionable

  def render(user)
    Renderer.call(self, user)
  end

  def perform(user)
    message = user.receive_message(body: render(user))
    notifications.create(message: message)
  end
end
