# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TwilioProvisioner do
  let(:organization) { create(:organization, twilio_account_sid: nil, twilio_auth_token: nil, phone_number: nil) }
  let!(:location) { create(:location, organization: organization, latitude: 37.870842, longitude: -122.501366, state: 'CA') }

  describe '#call' do
    context 'when the organization has a phone number' do
      before do
        organization.update(phone_number: Faker::PhoneNumber.cell_phone)
      end

      it 'does not update the organization' do
        expect do
          described_class.new(organization).call
        end.not_to change { organization.phone_number }
      end
    end

    context 'when the organization does not have a phone number', vcr: { cassette_name: 'TwilioProvisioner-call' } do
      it 'creates a twilio subaccount' do
        expect do
          expect do
            described_class.new(organization).call
          end.to change { organization.twilio_account_sid.present? }.from(false).to(true)
        end.to change { organization.twilio_auth_token.present? }.from(false).to(true)
      end

      it 'creates a phone number for the organization' do
        expect do
          described_class.new(organization).call
        end.to change { organization.phone_number.present? }.from(false).to(true)
      end
    end
  end
end
