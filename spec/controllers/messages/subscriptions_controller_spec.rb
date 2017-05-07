require 'rails_helper'

RSpec.describe Messages::SubscriptionsController, type: :controller do
  let(:phone_number) { '+15555555555' }

  describe '#create' do
    context 'broker subscription' do
      let(:params) do
        {
          'To' => ENV.fetch('BROKER_PHONE_NUMBER'),
          'From' => phone_number,
          'Body' => 'START',
          'MessageSid' => 'MESSAGE_SID'
        }
      end

      it 'creates a MessageSyncerJob to log the START message' do
        expect {
          post :create, params: params
        }.to have_enqueued_job(MessageSyncerJob)
      end

      context 'with a person' do
        let!(:person) { create(:person, :with_candidacy, phone_number: phone_number) }

        context 'without a contact' do
          it 'does not creates a subscribed contact' do
            expect {
              post :create, params: params
            }.to change { person.contacts.subscribed.count }.by(1)
          end
        end
    end

    context 'organization subscription' do
      let!(:organization) { create(:organization, phone_number: Faker::PhoneNumber.cell_phone) }
      let(:params) do
        {
          'To' => organization.phone_number,
          'From' => phone_number,
          'Body' => 'START',
          'MessageSid' => 'MESSAGE_SID'
        }
      end

      it 'creates a MessageSyncerJob to log the START message' do
        expect {
          post :create, params: params
        }.to have_enqueued_job(MessageSyncerJob)
      end

      context 'with a person' do
        let!(:person) { create(:person, :with_candidacy, phone_number: phone_number) }

        context 'without a contact' do
          it 'creates a subscribed contact' do
            expect {
              post :create, params: params
            }.to change { person.contacts.subscribed.count }.by(1)
          end
        end

        context 'with a subscribed contact' do
          let!(:contact) { create(:contact, subscribed: true, person: person, organization: organization) }
          it 'creates an AlreadySubscribedJob' do
            expect {
              post :create, params: params
            }.to have_enqueued_job(AlreadySubscribedJob)
          end

          it 'does not create a contact' do
            expect {
              post :create, params: params
            }.not_to change { Contact.count }
          end

          it 'does not create an IceBreakerJob' do
            expect {
              post :create, params: params
            }.not_to have_enqueued_job(IceBreakerJob)
          end
        end
      end

      context 'without a person' do
        it 'creates a person' do
          expect {
            post :create, params: params
          }.to change { Person.count }.by(1)
        end

        it 'creates a candidacy' do
          expect {
            post :create, params: params
          }.to change { Candidacy.count }.by(1)
        end

        it 'creates a subscribed contact' do
          expect {
            post :create, params: params
          }.to change { Contact.subscribed.count }.by(1)
        end

        it 'creates an IceBreakerJob' do
          expect {
            post :create, params: params
          }.to have_enqueued_job(IceBreakerJob)
        end

        it 'does not create an AlreadySubscribedJob' do
          expect {
            post :create, params: params
          }.not_to have_enqueued_job(AlreadySubscribedJob)
        end

        it 'does create an SurveyorJob' do
          expect {
            post :create, params: params
          }.to have_enqueued_job(SurveyorJob)
        end
      end
    end
  end

  describe '#destroy' do
    let(:params) do
      {
        'To' => organization.phone_number,
        'From' => phone_number,
        'Body' => 'STOP',
        'MessageSid' => 'MESSAGE_SID'
      }
    end

    it 'creates a MessageSyncerJob to log the STOP message' do
      expect {
        delete :destroy, params: params
      }.to have_enqueued_job(MessageSyncerJob)
    end

    context 'with a person' do
      let!(:person) { create(:person, :with_candidacy, phone_number: phone_number) }

      context 'without a contact' do
        it 'create an unsubscribed contact' do
          expect {
            delete :destroy, params: params
          }.to change { person.contacts.unsubscribed.count }.by(1)
        end
      end

      context 'with a subscribed contact' do
        let!(:contact) { create(:contact, subscribed: true, person: person, organization: organization) }
        it 'unsubscribes the contact' do
          expect {
            delete :destroy, params: params
          }.to change { contact.reload.subscribed? }.from(true).to(false)
        end
      end
    end

    context 'without a person' do
      it 'creates a person' do
        expect {
          delete :destroy, params: params
        }.to change { Person.count }.by(1)
      end

      it 'creates a candidacy' do
        expect {
          delete :destroy, params: params
        }.to change { Candidacy.count }.by(1)
      end

      it 'creates an unsubscribed contact' do
        expect {
          delete :destroy, params: params
        }.to change { Contact.unsubscribed.count }.by(1)
      end
    end
  end
end
