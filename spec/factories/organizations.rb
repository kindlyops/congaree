FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    industry
    twilio_account_sid ENV.fetch('TWILIO_TEST_ACCOUNT_SID')
    twilio_auth_token ENV.fetch('TWILIO_TEST_AUTH_TOKEN')

    trait :with_phone do
      after(:create) do |organization|
        create(:phone, organization: organization)
      end
    end

    trait :with_account do
      after(:create) do |organization|
        create(:account, organization: organization)
      end
    end

    trait :with_owner do
      after(:create) do |organization|
        create(:account, role: Account.roles[:owner], organization: organization)
      end
    end

    trait :with_successful_phone do
      after(:create) do |organization|
        create(:phone, :successful, organization: organization)
      end
    end
  end
end
