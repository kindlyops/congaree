require 'rails_helper'

RSpec.describe Organizations::MessagesController, type: :controller do
  let(:organization) { create(:organization, :account, :phone_number) }
  let!(:stage) { create(:contact_stage, organization: organization) }
  let!(:phone_number) { organization.phone_numbers.first.phone_number }

  describe '#create' do
    context 'new person' do
      let(:params) do
        {
          'To' => phone_number,
          'From' => '+14041234567',
          'Body' => 'Answer',
          'MessageSid' => 'MESSAGE_SID'
        }
      end

      it 'creates a person' do
        expect {
          post :create, params: params
        }.to change { Person.count }.by(1)
      end

      it 'creates a contact candidacy' do
        expect {
          post :create, params: params
        }.to change { ContactCandidacy.count }.by(1)
      end

      it 'creates a subscribed contact' do
        expect {
          post :create, params: params
        }.to change { Contact.subscribed.count }.by(1)
      end

      context 'with contact stages' do
        let!(:stage) { create(:contact_stage, organization: organization) }

        it 'sets the stage of the contact as the first stage' do
          post :create, params: params
          expect(Contact.last.stage).to eq(stage)
        end
      end

      it 'adds the contact to the existing team' do
        post :create, params: params
        expect(organization.contacts).to include(Contact.last)
      end
    end

    context 'existing person' do
      let!(:person) { create(:person) }

      let(:params) do
        {
          'To' => phone_number,
          'From' => person.phone_number,
          'Body' => 'Answer',
          'MessageSid' => 'MESSAGE_SID'
        }
      end

      it 'creates a DeliveryAgentJob' do
        expect {
          post :create, params: params
        }.to have_enqueued_job(DeliveryAgentJob)
      end

      it 'does not create a person' do
        expect {
          post :create, params: params
        }.not_to change { Person.count }
      end

      it 'creates a subscribed contact' do
        expect {
          post :create, params: params
        }.to change { person.contacts.subscribed.count }.by(1)
      end

      it 'sets the stage of the contact as the first stage' do
        post :create, params: params
        expect(person.contacts.last.stage).to eq(stage)
      end

      it 'creates a contact candidacy' do
        expect {
          post :create, params: params
        }.to change { ContactCandidacy.count }.by(1)
      end

      it 'adds the contact to the existing team' do
        post :create, params: params
        expect(organization.contacts).to include(Contact.last)
      end
    end
  end
end
