class Goal < ApplicationRecord
  belongs_to :bot
  belongs_to :contact_stage, optional: true

  validates :rank, :body, presence: true

  before_validation :ensure_rank

  def self.ranked
    order(:rank)
  end

  def trigger(message, campaign_contact)
    Bot::GoalTrigger.call(self, message, campaign_contact)
  end

  def tag(contact)
    contact.update(stage: contact_stage) if contact_stage.present?
  end

  private

  def ensure_rank
    return if rank.present?
    self.rank = bot.next_goal_rank
  end
end
