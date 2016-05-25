FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    twilio_account_sid ENV.fetch('TWILIO_TEST_ACCOUNT_SID')
    twilio_auth_token ENV.fetch('TWILIO_TEST_AUTH_TOKEN')
    after(:create) do |organization|
      create(:phone, organization: organization)
    end

    trait :with_automation do |organization|
      after(:create) do |organization|
        create(:automation, :with_rule, answer: true, organization: organization)
      end
    end

    trait :with_account do
      after(:create) do |organization|
        create(:user, :with_account, organization: organization)
      end
    end

    trait :with_contact do
      after(:create) do |organization|
        create(:user, contact: true, organization: organization)
      end
    end
  end
end
