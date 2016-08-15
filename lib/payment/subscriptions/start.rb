class Payment::Subscriptions::Start

  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    if organization.stripe_customer_id.blank?
      stripe_customer = create_stripe_customer_with_subscription
      stripe_subscription = stripe_customer.subscriptions.first
    else
      stripe_customer = find_stripe_customer
      stripe_subscription = create_stripe_subscription(stripe_customer)
    end

    subscription.update(
      stripe_id:               stripe_subscription.id,
      application_fee_percent: stripe_subscription.application_fee_percent,
      cancel_at_period_end:    stripe_subscription.cancel_at_period_end,
      canceled_at:             stripe_subscription.canceled_at,
      stripe_created_at:       stripe_subscription.created,
      current_period_end:      stripe_subscription.current_period_end,
      current_period_start:    stripe_subscription.current_period_start,
      stripe_customer_id:      stripe_subscription.customer,
      ended_at:                stripe_subscription.ended_at,
      quantity:                stripe_subscription.quantity,
      start:                   stripe_subscription.start,
      status:                  stripe_subscription.status,
      tax_percent:             stripe_subscription.tax_percent,
      trial_end:               stripe_subscription.trial_end,
      trial_start:             stripe_subscription.trial_start
    )

    subscription.activate!
  rescue Stripe::StripeError => e
    subscription.update(error: e.message)
    subscription.fail!
  ensure
    subscription
  end

  private

  attr_reader :subscription

  def find_stripe_customer
    Stripe::Customer.retrieve(organization.stripe_customer_id)
  end

  def create_stripe_customer_with_subscription
    stripe_customer = Stripe::Customer.create(
      source:   organization.stripe_token,
      plan:     subscription.plan_stripe_id,
      quantity: subscription.quantity
    )
    organization.update(stripe_customer_id: stripe_customer.id)
    stripe_customer
  end

  def create_stripe_subscription(stripe_customer)
    Stripe::Subscription.create(
      customer: stripe_customer.id,
      plan:     subscription.plan_stripe_id,
      quantity: subscription.quantity
    )
  end

  def organization
    @organization ||= subscription.organization
  end
end
