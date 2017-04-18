class Broadcaster::Message
  def initialize(message)
    @message = message
  end

  def broadcast
    MessagesChannel.broadcast_to(contact, render_message)
  end

  private

  attr_reader :message

  def contact
    @contact ||= contacts.find_by(person: person)
  end

  delegate :organization, :person, to: :message
  delegate :contacts, to: :organization

  def render_message
    ContactWrapper.new(contact).render(message)
  end
end
