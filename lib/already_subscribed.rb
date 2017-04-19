class AlreadySubscribed
  def self.call(contact)
    new(contact).call
  end

  def initialize(contact)
    @contact = contact
  end

  def call
    organization.message(
      sender: Chirpy.person,
      recipient: person,
      body: already_subscribed
    )
  end

  private

  attr_reader :contact
  delegate :person, :organization, to: :contact

  def already_subscribed
    'You are already subscribed. '\
    "Thanks for your interest in #{organization.name}."
  end
end
