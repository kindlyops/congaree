require 'rails_helper'

RSpec.describe IceBreaker do
  let(:contact) { create(:contact) }
  let(:organization) { contact.organization }

  subject { IceBreaker.new(contact) }

  describe '#call' do
    context 'with multiple accounts on the organization' do
      let!(:accounts) { create_list(:account, 3, :inbox, organization: contact.organization) }
      let(:count) { organization.accounts.count }

      it 'creates a conversation for each account on the organization' do
        expect {
          subject.call
        }.to change { organization.inbox_conversations.count }.by(count)
      end

      it 'ties the conversations to inboxes' do
        subject.call
        expect(organization.inbox_conversations.map(&:inbox).all?(&:present?)).to eq(true)
      end

      context 'with existing conversations' do
        before do
          create(:inbox_conversation, inbox: accounts.first.inbox, contact: contact)
        end

        it 'creates a conversation for just accounts without a conversation' do
          expect {
            subject.call
          }.to change { organization.inbox_conversations.count }.by(count - 1)
        end
      end
    end

    context 'with accounts on other organizations' do
      let!(:accounts) { create_list(:account, 3) }
      let(:count) { organization.accounts.count }

      it 'only creates conversations for accounts on the organization' do
        expect {
          subject.call
        }.to change { organization.inbox_conversations.count }.by(count)
      end
    end
  end
end
