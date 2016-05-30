class Rule < ActiveRecord::Base
  belongs_to :action, polymorphic: true
  belongs_to :organization
  belongs_to :trigger
  delegate :perform, to: :action

  validates :trigger, :organization, :action, presence: true
  delegate :template_name, to: :action, prefix: true
  delegate :template_name, :event, to: :trigger, prefix: true

  validates :action_type, inclusion: { in: %w(Notice Question) }

end
