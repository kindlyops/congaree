Messaging::Client.master = Twilio::REST::Client.new(
  ENV.fetch('TWILIO_TEST_ACCOUNT_SID'), ENV.fetch('TWILIO_TEST_AUTH_TOKEN')
)

if Rails.env.production?
  Messaging::Client.client = Twilio::REST::Client
else
  Messaging::Client.client = FakeMessaging
  Messaging::Client.master.accounts.define_singleton_method(:get) do |_sid|
    account = Object.new
    def account.update(_options = {})
      true
    end
    account
  end
end
