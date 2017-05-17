class PhoneNumberProvisioner
  def initialize(team)
    @team = team
  end

  def self.provision(team)
    new(team).provision
  end

  def provision
    return if team.phone_number.present?

    sub_account.incoming_phone_numbers.create(phone_number_attributes)
    team.update(phone_number: available_local_phone_number)
    add_sub_account_to_organization unless organization.subaccount?
  end

  private

  def add_sub_account_to_organization
    organization.update(twilio_account_sid: sub_account.sid,
                        twilio_auth_token: sub_account.auth_token)
  end

  def phone_number_attributes
    {
      phone_number: available_local_phone_number,
      voice_url: nil,
      sms_url: "#{ENV.fetch('TWILIO_WEBHOOK_BASE')}/twilio/text",
      capabilities: {
        voice: false,
        sms: true,
        mms: true
      }
    }
  end

  def sub_account
    @sub_account ||= begin
      if organization.twilio_account_sid.present?
        master_client.accounts.get(organization.twilio_account_sid)
      else
        master_client.accounts.create(friendly_name: organization.name)
      end
    end
  end

  def available_local_phone_numbers
    @available_local_phone_numbers ||= begin
      local_numbers = sub_account.available_phone_numbers.get('US').local
      lat_long = "#{location.latitude},#{location.longitude}"
      local_numbers.list(
        near_lat_long: lat_long,
        in_region: location.state_code.to_s
      )
    end
  end

  def available_local_phone_number
    available_local_phone_numbers[0].phone_number
  end

  def master_client
    Messaging::Client.master
  end

  attr_reader :team

  delegate :organization, to: :team
  delegate :location, to: :organization
end
