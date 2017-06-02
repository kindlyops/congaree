class Conversation < ApplicationRecord
  belongs_to :contact
  has_many :inbox_conversations
  has_many :inboxes, through: :inbox_conversations
  has_many :messages

  delegate :person, :handle, to: :contact

  enum state: {
    'Open' => 0, 'Closed' => 1
  }

  def self.by_recent_message
    order(last_message_created_at: :desc)
  end

  def unread_count(inbox)
    inbox_conversations.find_by(inbox: inbox).unread_count
  end

  def days
    messages.by_recency.chunk(&:day).map(&method(:to_day))
  end

  def day(date)
    result = messages.by_recency.chunk(&:day).find do |day, _|
      day == date
    end

    to_day(result)
  end

  private

  def to_day(day)
    Conversation::Day.new(day)
  end
end
