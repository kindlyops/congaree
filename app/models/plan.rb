class Plan < ApplicationRecord

  def self.messages_per_quantity
    @messages_per_quantity ||= 500
  end

  def self.messages_per_quantity=(quantity)
    @messages_per_quantity = quantity
  end

  DEFAULT_QUANTITY = 2
  DEFAULT_PRICE_IN_DOLLARS = 50
  TRIAL_MESSAGE_LIMIT = 250
end
