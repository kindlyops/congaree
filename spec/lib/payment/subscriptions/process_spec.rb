# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Payment::Subscriptions::Process do
  subject { described_class.new(subscription, email) }

  let(:card) do
    {
      number: '4242424242424242',
      exp_month: '8',
      exp_year: 1.year.from_now.year,
      cvc: '123'
    }
  end

  let!(:stripe_token) { Stripe::Token.create(card: card) }
  let!(:stripe_plan) { Stripe::Plan.create(id: 'test', amount: 5_000, currency: 'usd', interval: 'month', name: 'test') }

  let!(:plan) { create(:plan, stripe_id: stripe_plan.id) }
  let!(:subscription) { create(:subscription, plan: plan, organization: organization, state: 'active') }

  after do
    stripe_plan.delete
  end

  let(:email) { 'frank.paucek@heathcote.com' }

  describe '#call' do
    context 'without an existing stripe customer', vcr: { cassette_name: 'Payment::Subscriptions::Process-call-without-stripe-customer' } do
      let(:organization) { create(:organization, name: 'Little-Abshire', stripe_token: stripe_token.id) }

      before do
        organization.update(stripe_customer_id: nil)
      end

      it 'creates a stripe customer' do
        expect do
          subject.call
        end.to change { organization.reload.stripe_customer_id }.from(nil)
      end

      it 'updates the local subscription' do
        expect do
          subject.call
        end.to change { subscription.reload.stripe_id }.from(nil)
      end

      it 'sets the description and email on the stripe customer', vcr: { cassette_name: 'Payment::Subscriptions::Process-call-without-stripe-customer-desc-email' } do
        subject.call
        stripe_customer = Stripe::Customer.retrieve(organization.reload.stripe_customer_id)
        expect(stripe_customer.description).to eq(organization.name)
        expect(stripe_customer.email).to eq(email)
      end
    end

    context 'with an existing stripe customer', vcr: { cassette_name: 'Payment::Subscriptions::Process-call-with-stripe-customer' } do
      let(:stripe_customer) { Stripe::Customer.create }
      let!(:stripe_card) { stripe_customer.sources.create(source: stripe_token.id) }
      let!(:organization) { create(:organization, stripe_customer_id: stripe_customer.id) }

      after do
        stripe_customer.delete
      end

      it 'does not create a new stripe customer' do
        expect do
          subject.call
        end.not_to change { organization.reload.stripe_customer_id }
      end

      it 'updates the local subscription' do
        expect do
          subject.call
        end.to change { subscription.reload.stripe_id }.from(nil)
      end
    end
  end
end
