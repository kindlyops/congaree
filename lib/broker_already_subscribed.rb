class BrokerAlreadySubscribed
  def self.call(broker_contact)
    new(broker_contact).call
  end

  def initialize(broker_contact)
    @broker_contact = broker_contact
  end

  def call
    broker.message(
      sender: Chirpy.person,
      recipient: person,
      body: already_subscribed
    )
  end

  private

  attr_reader :broker_contact
  delegate :person, :broker, to: :broker_contact

  def already_subscribed
    <<~BODY
      Hey there!

      How can I help?

      Chirpy
    BODY
  end
end
