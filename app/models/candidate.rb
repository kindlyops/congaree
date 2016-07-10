class Candidate < ApplicationRecord
  include PublicActivity::Common
  has_many :activities, as: :trackable

  belongs_to :user
  belongs_to :candidate_persona
  has_many :candidate_features
  has_many :referrals
  has_many :referrers, through: :referrals

  alias :features :candidate_features

  STATUSES = ["Potential", "Qualified", "Bad Fit"]
  validates :status, inclusion: { in: STATUSES }

  delegate :first_name, :phone_number, :organization_name,
           :organization, :messages, :outstanding_inquiry,
           :receive_message, to: :user

  delegate :contact_first_name, to: :organization
  delegate :created_at, to: :last_referral, prefix: true

  scope :subscribed, -> { where(subscribed: true) }

  def last_referral
    @last_referral ||= begin
      return NullReferral.new unless referrals.present?
      referrals.order(:created_at).last
    end
  end

  def next_persona_feature
    candidate_persona.features.next_for(self)
  end

  def last_referrer
    @last_referrer ||= begin
      return NullReferrer.new unless referrers.present?
      last_referral.referrer
    end
  end

  def unsubscribed?
    !subscribed?
  end

  def address_feature
    candidate_features.where("properties->>'child_class' = ?", "address").first
  end

  def choice_features
    candidate_features.where("properties->>'child_class' = ?", "choice")
  end
end
