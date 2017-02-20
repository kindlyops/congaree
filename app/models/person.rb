class Person < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :candidacy
  has_many :subscribers
  has_many :messages

  before_create :add_nickname
  after_create :create_candidacy

  delegate :inquiry, :zipcode, to: :candidacy

  def subscribed_to?(organization)
    subscribers.where(organization: organization).exists?
  end

  def subscribed_to(organization)
    subscribers.find_by(organization: organization)
  end

  def handle
    full_name || nickname
  end

  private

  def add_nickname
    self.nickname = Nickname::Generator.new(self).generate
  rescue Nickname::OutOfNicknames => e
    Rollbar.debug(e)
    self.nickname = 'Anonymous'
  end
end
