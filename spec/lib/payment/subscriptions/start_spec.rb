require 'rails_helper'

RSpec.describe Payment::Subscriptions::Start do
  subject { Payment::Subscriptions::Start.new(subscription) }

  describe "#call" do
    context "without an existing stripe customer", stripe: { token: :visa } do
      let(:organization) { create(:organization, stripe_token: stripe_token.id) }
      let(:subscription) { create(:subscription, organization: organization, state: "processing") }

      before(:each) do
        organization.update(stripe_customer_id: nil)
      end

      it "creates a stripe customer" do
        expect{
          subject.call
        }.to change{organization.reload.stripe_customer_id}.from(nil)
      end

      it "creates a subscription through the customer" do
        expect {
          subject.call
        }.to change{subscription.reload.stripe_customer_id}.from(nil)
        expect(organization.subscription.stripe_customer_id).to eq(organization.reload.stripe_customer_id)
      end

      it "updates the local subscription" do
        expect{
          subject.call
        }.to change{subscription.reload.stripe_id}.from(nil)
      end

      it "activates the subscription" do
        expect {
          subject.call
        }.to change{subscription.reload.state}.from("processing").to("active")
      end
    end

    context "with an existing stripe customer", stripe: { customer: :new, plan: "test", card: :visa } do
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }
      let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
      let!(:subscription) { create(:subscription, plan: plan, organization: organization, state: "processing") }

      it "does not create a new stripe customer" do
        expect{
          subject.call
        }.not_to change{organization.reload.stripe_customer_id}
      end

      it "creates a subscription through the customer" do
        expect {
          subject.call
        }.to change{subscription.reload.stripe_customer_id}.from(nil)
        expect(organization.subscription.stripe_customer_id).to eq(organization.reload.stripe_customer_id)
      end

      it "updates the local subscription" do
        expect{
          subject.call
        }.to change{subscription.reload.stripe_id}.from(nil)
      end

      it "activates the subscription" do
        expect {
          subject.call
        }.to change{subscription.reload.state}.from("processing").to("active")
      end
    end
  end
end
