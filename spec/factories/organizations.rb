FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }

    trait :team do
      after(:create) do |organization|
        create(:team, organization: organization)
      end
    end

    trait :team_without_inbox do
      after(:create) do |organization|
        create(:team, with_inbox: false, organization: organization)
      end
    end

    trait :team_with_phone_number_and_recruiting_ad do
      after(:create) do |organization|
        create(:team, :phone_number, :recruiting_ad, organization: organization)
      end
    end

    trait :account do
      after(:create) do |organization|
        account = create(:account, :inbox, organization: organization)
        organization.update(recruiter: account)
      end
    end

    trait :recruiting_ad do
      after(:create) do |organization|
        create(:recruiting_ad, organization: organization)
      end
    end

    trait :phone_number do
      phone_number { Faker::PhoneNumber.cell_phone }
    end
  end
end
