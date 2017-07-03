require 'rails_helper'

RSpec.describe Bot::GoalTrigger do
  let!(:organization) { create(:organization, :team) }
  let(:phone_number) { organization.phone_numbers.first }

  let(:bot) { create(:bot, organization: organization) }
  let(:campaign) { create(:campaign, organization: organization) }
  let(:bot_campaign) { create(:bot_campaign, campaign: campaign, bot: bot) }
  let(:goal) { bot.goals.first }

  let(:team) { organization.teams.first }
  let(:inbox) { team.inbox }
  let(:contact) { create(:contact, organization: organization) }
  let(:conversation) { create(:conversation, inbox: inbox, contact: contact) }

  let(:message) { create(:message, conversation: conversation) }
  let(:campaign_contact) { create(:campaign_contact, phone_number: phone_number, contact: contact, campaign: campaign) }

  subject { Bot::GoalTrigger.new(goal, message, campaign_contact) }

  describe '#call' do
    context 'with multiple accounts on the team' do
      before do
        team.accounts << create_list(:account, rand(1..3))
      end

      it 'sends an email to the account on the same team only' do
        expect {
          subject.call
        }.to have_enqueued_job(ActionMailer::DeliveryJob)
          .with { |mailer, mailer_method, *_args|
               expect(mailer).to eq('NotificationMailer')
               expect(mailer_method).to eq('contact_ready_for_review')
             }.exactly(team.accounts.count).times
      end
    end

    it 'broadcasts the contact' do
      expect(Broadcaster::Contact).to receive(:broadcast)

      subject.call
    end

    context 'with tags' do
      before do
        goal.tags << create_list(:tag, rand(2..4))
      end

      it 'adds the tags to the contact' do
        expect {
          subject.call
        }.to change { contact.reload.tags.count }.by(goal.tags.count)
      end
    end
  end
end
