# frozen_string_literal: true
module Payment
  module Subscriptions
    class Update
      def self.call(subscription)
        new(subscription).call
      end

      def initialize(subscription)
        @subscription = subscription
      end

      def call
        stripe_subscription.quantity = subscription.quantity
        stripe_subscription.save
      end

      private

      def stripe_subscription
        @stripe_subscription ||= begin
          Stripe::Subscription.retrieve(subscription.stripe_id)
        end
      end

      attr_reader :subscription
    end
  end
end
