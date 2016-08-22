require 'rails_helper'

RSpec.describe Payment::Job::UpdateSubscription do
  let(:subscription) { create(:subscription) }

  describe "#perform" do
    it "calls Update Service" do
      expect(Payment::Subscriptions::Update).to receive(:call).with(subscription)
      Payment::Job::UpdateSubscription.perform_now(subscription)
    end

    it "calls the SurveyAdvancer service" do
      allow(Payment::Subscriptions::Update).to receive(:call).with(subscription)
      expect(SurveyAdvancer).to receive(:call).with(subscription.organization)
      Payment::Job::UpdateSubscription.perform_now(subscription)
    end
  end
end
