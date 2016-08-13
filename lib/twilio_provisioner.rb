class TwilioProvisioner

  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization = organization
  end

  def call
    return if organization.phone_number.present?

    sub_account.incoming_phone_numbers.create(phone_number: available_local_phone_number)
    organization.update(
      phone_number: available_local_phone_number,
      twilio_account_sid: sub_account.sid,
      twilio_auth_token: sub_account.auth_token
    )
  end

  private

  def sub_account
    @sub_account ||= $twilio.accounts.create(friendly_name: organization.name)
  end

  def available_local_phone_numbers
    @available_local_phone_numbers ||= sub_account.available_phone_numbers.get('US').local.list(in_postal_code: location.postal_code)
  end

  def available_local_phone_number
    @available_local_phone_number ||= available_local_phone_numbers[0].phone_number
  end

  attr_reader :organization

  delegate :location, to: :organization

end
