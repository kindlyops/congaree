# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  puts "Creating Organization"
  org = Organization.find_or_create_by(
    name: "chirpyhire",
    twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
    twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
    phone_number: ENV.fetch("TEST_ORG_PHONE")
  )
  puts "Created Organization"

  puts "Creating User"
  user = User.find_or_create_by(
   first_name: "Harry",
   last_name: "Whelchel",
   phone_number: ENV.fetch("DEV_PHONE"),
   organization: org
  )
  puts "Created User"

  puts "Creating Account"
  email = ENV.fetch("DEV_EMAIL")
  unless user.account.present?
    user.create_account(password: "password", password_confirmation: "password", user: user, email: email, super_admin: true)
  end
  puts "Created Account"

  puts "Creating Referrer"
  Referrer.find_or_create_by(user: user)
  puts "Created Referrer"

  puts "Creating Candidate"
  candidate = Candidate.find_or_create_by(user: user)
  puts "Created Candidate"

  unless org.profile.present?
    profile = org.create_profile
    profile.features.create(format: "document", name: "TB Test")
    profile.features.create(format: "address", name: "Address and Zipcode")
    puts "Created Profile and Features"
  end

  unless org.templates.present?
    welcome = org.templates.create(name: "Welcome", body: "Hello this is {{organization.name}}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    thank_you = org.templates.create(name: "Thank You", body: "Thanks for your interest!")
    puts "Created Templates"
  end

  unless org.rules.present?
    subscribe_rule = org.rules.create(trigger: "subscribe", action: welcome)
    subscribe_rule_2 = org.rules.create(trigger: "subscribe", action: profile)
    answer_rule = org.rules.create(trigger: "answer", action: profile)
    screen_rule = org.rules.create(trigger: "screen", action: thank_you)
    puts "Created Rules"
  end

  unless user.tasks.present?
    raw_messages = org.send(:messaging_client).messages.list.select do |message|
      message.direction == "inbound"
    end

    bodies = ["Will my CNA license from Florida transfer?",
              "Will you hire me if I just have my PCA?"]

    NEEDED_SIDS = ["MMcb3589b5256ee750a86f05dc5e418e31", "SM3ca817b0df3d27e633d0eaa111d5561c", "SM141d3c61f986414fb8db473078e68b24"]

    needed_messages = raw_messages.select{|m| NEEDED_SIDS.include?(m.sid) }
    needed_messages.each do |message|
      MessageHandler.call(user, Messaging::Message.new(message))
    end

    ok_messages = raw_messages.reject{|m| NEEDED_SIDS.include?(m.sid) }

    2.times do |i|

      message = MessageHandler.call(user, Messaging::Message.new(ok_messages[i]))
      message.update(body: bodies[i], created_at: rand(6.hours.ago..Time.now))

      FactoryGirl.create(:task, user: user, taskable: message)
    end

    FactoryGirl.create(:task, user: user, taskable: user.candidate)
    puts "Created Tasks"
  end

  unless user.inquiries.present?
    profile = org.profile
    inquiry = ProfileAdvancer.call(user, org.profile)
    sids = {
      document: "MMcb3589b5256ee750a86f05dc5e418e31",
      address: "SM3ca817b0df3d27e633d0eaa111d5561c"
    }
    first_answer_message = Message.find_by(sid: sids[inquiry.format.to_sym])
    first_answer_message.update(created_at: 4.hours.ago)
    inquiry.message.update(created_at: 4.hours.ago - 5.minutes)
    inquiry.create_answer(message: first_answer_message)
    inquiry = ProfileAdvancer.call(user, org.profile)
    second_answer_message = Message.find_by(sid: sids[inquiry.format.to_sym])
    second_answer_message.update(created_at: 3.hours.ago)
    inquiry.message.update(created_at: 3.hours.ago - 5.minutes)
    address_answer = inquiry.create_answer(message: second_answer_message)

    candidate.candidate_profile_features.last.update(properties: Address.extract(second_answer_message))

    puts "Created Inquiries, Answers"
  end

  unless user.notifications.present?
    thank_you = org.templates.find_by(body: "Thanks for your interest!")
    thank_you_sid = "SM141d3c61f986414fb8db473078e68b24"

    thank_you_message = Message.find_or_create_by(user: user, sid: thank_you_sid, body: thank_you.body, direction: "outbound-api")
    thank_you_message.update(created_at: 2.hours.ago)
    thank_you.notifications.create(message: thank_you_message)

    puts "Created Notification"
  end

  puts "Development specific seeding completed"
end

puts "Seed completed"

