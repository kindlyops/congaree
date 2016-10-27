class Message < ApplicationRecord
  has_many :media_instances

  belongs_to :user
  has_one :inquiry
  has_one :answer
  has_one :notification
  belongs_to :child, class_name: 'Message'
  delegate :organization, to: :user

  def self.by_recency
    order(external_created_at: :desc, id: :desc)
  end

  def self.current_month
    beginning_of_month = DateTime.current.beginning_of_month
    end_of_month = DateTime.current.end_of_month

    where(created_at: beginning_of_month..end_of_month)
  end

  def self.last_month
    where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
  end

  def self.by_read_status
    joins(:user).merge(User.by_having_unread_messages)
  end

  def self.conversations
    where(child: nil)
  end

  def media
    media_instances
  end

  delegate :images, to: :media_instances

  def inbound?
    direction == 'inbound'
  end

  def images?
    return media_instances.any?(&:image?) unless persisted?
    media_instances.images.present?
  end

  def address?
    return false unless body.present?
    address.found?
  end

  def yes_or_no?
    return false unless body.present?
    YesNoQuestion::REGEXP =~ body.strip.downcase
  end

  def choice?(choices)
    return false unless body.present? && choices.present?
    (Regexp.new("\\A([#{choices}]){1}\\)?\\z") =~ body.strip.downcase).present?
  end

  def valid_zipcode?
    return false unless body.present?
    (body =~ /^\d{5}$/) == 0
  end

  def address
    @address ||= AddressFinder.new(body)
  end
end
