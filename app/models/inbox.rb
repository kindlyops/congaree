class Inbox < ApplicationRecord
  belongs_to :account
  has_many :inbox_conversations
  has_many :conversations, through: :inbox_conversations

  def conversation(contact)
    conversations.find_by(contact: contact)
  end

  def to_builder
    conversations = inbox_conversations.by_recent_message.limit(25).map do |c|
      c.to_builder.attributes!
    end

    Jbuilder.new do |json|
      json.id id
      json.conversations_count inbox_conversations.count
      json.conversations conversations
    end
  end
end
