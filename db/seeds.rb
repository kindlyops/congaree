# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  puts "Creating Organization"
  org = Organization.find_or_create_by!(
    name: "Happy Home Care",
    twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
    twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
    phone_number: ENV.fetch("TEST_ORG_PHONE")
  )
  puts "Created Organization"

  puts "Creating User"
  user = User.find_or_create_by!(
   first_name: "Harry",
   last_name: "Whelchel",
   phone_number: ENV.fetch("DEV_PHONE"),
   organization: org
  )
  puts "Created User"

  puts "Creating Account"
  email = ENV.fetch("DEV_EMAIL")
  unless user.account.present?
    user.create_account!(password: "password", password_confirmation: "password", user: user, email: email, super_admin: true)
  end
  puts "Created Account"

  puts "Creating Referrer"
  Referrer.find_or_create_by(user: user)
  puts "Created Referrer"

  unless org.templates.present?
    welcome = org.templates.create!(name: "Welcome", body: "Hello this is {{organization.name}}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    thank_you = org.templates.create!(name: "Thank You", body: "Thanks for your interest!")
    puts "Created Templates"
  end

  unless org.candidate_persona.present?
    candidate_persona = org.create_candidate_persona
    candidate_persona.create_template(
      name: "Bad Fit - Default",
      organization: org,
      body: "Thank you very much for your interest. Unfortunately, we don't "\
      "have a good fit for you at this time. If anything changes we will let you know.")
  end

  unless org.candidate_persona.persona_features.present?
    org.candidate_persona.persona_features.create!(priority: 1, category: Category.create(name: "Address"), format: "address", text: "What is your address and zipcode?", properties: { distance: 20, latitude: 33.929966, longitude: -84.373931 })
    org.candidate_persona.persona_features.create!(priority: 2, category: Category.create(name: "Availability"), format: "choice", text: "What is your availability?", properties: { choice_options: { a: "Live-in", b: "Hourly", c: "Both" }})
    org.candidate_persona.persona_features.create!(priority: 3, category: Category.create(name: "CNA License"), format: "document", text: "Please send us a photo of your CNA license.")
    puts "Created Profile Features"
  end

  unless org.rules.present?
    subscribe_rule = org.rules.create!(trigger: "subscribe", actionable: welcome.create_actionable)
    subscribe_rule_2 = org.rules.create!(trigger: "subscribe", actionable: org.candidate_persona.create_actionable)
    answer_rule = org.rules.create!(trigger: "answer", actionable: org.candidate_persona.actionable)
    screen_rule = org.rules.create!(trigger: "screen", actionable: thank_you.create_actionable)
    puts "Created Rules"
  end

  FactoryGirl.create_list(:candidate, 5, :with_address, status: "Bad Fit", organization: org)
  FactoryGirl.create_list(:candidate, 5, :with_address, status: "Qualified", organization: org)
  FactoryGirl.create_list(:candidate, 5, :with_address, status: "Potential", organization: org)
  FactoryGirl.create_list(:candidate, 5, :with_address, status: "Hired", organization: org)

  puts "Development specific seeding completed"
end

puts "Seed completed"

