# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Template, type: :model do
  subject { create(:template) }

  describe '#perform' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }

    it 'sends a message to the user' do
      expect do
        subject.perform(user)
      end.to change { FakeMessaging.messages.count }.by(1)
    end

    it 'creates an notification' do
      expect do
        subject.perform(user)
      end.to change { subject.notifications.count }.by(1)
    end
  end
end
