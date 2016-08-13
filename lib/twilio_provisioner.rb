class TwilioProvisioner

  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization = organization
  end

  def call
    return if organization.phone_number.present?

    sub_account.incoming_phone_numbers.create(
      phone_number: available_local_phone_number,
      voice_url: nil,
      sms_url: "https://app.chirpyhire.com/twilio/text",
      capabilities: {
        voice: false,
        sms: true,
        mms: true
    })
    organization.update(update_params)
  end

  private

  def sub_account
    @sub_account ||= begin
      if organization.twilio_account_sid.present?
        $twilio.accounts.get(organization.twilio_account_sid)
      else
        $twilio.accounts.create(friendly_name: organization.name)
      end
    end
  end

  def available_local_phone_numbers
    @available_local_phone_numbers ||= sub_account.available_phone_numbers.get('US').local.list(in_postal_code: location.postal_code)
  end

  def available_local_phone_number
    @available_local_phone_number ||= available_local_phone_numbers[0].phone_number
  end

  def update_params
    params = { phone_number: available_local_phone_number }
    return params if organization.twilio_account_sid.present?

    params.merge(twilio_account_sid: sub_account.sid, twilio_auth_token: sub_account.auth_token)
  end

  attr_reader :organization

  delegate :location, to: :organization

end
