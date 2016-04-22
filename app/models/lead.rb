class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :referrers, through: :referrals
  has_many :inquiries
  has_many :answers
  has_many :search_leads
  has_many :searches, through: :search_leads
  has_many :search_questions, through: :searches
  has_many :questions, through: :search_questions

  delegate :first_name, :name, :phone_number, to: :user

  scope :subscribed, -> { joins(user: :subscriptions) }

  def referrer
    @referrer ||= begin
      return NullReferrer.new unless referrers.present?
      referrers.first
    end
  end

  def referrer_name
    referrer.name
  end

  def referrer_phone_number
    referrer.phone_number
  end

  def subscribe
    user.subscribe_to(organization)
  end

  def subscribed?
    user.subscribed_to?(organization)
  end

  def unsubscribe
    user.unsubscribe_from(organization)
  end

  def unsubscribed?
    user.unsubscribed_from?(organization)
  end

  def has_other_search_in_progress?(search)
    search_leads.where.not(search: search).processing.exists?
  end

  def has_pending_searches?
    search_leads.pending.exists?
  end

  def oldest_pending_search_lead
    search_leads.pending.order(:created_at).first
  end

  def recently_answered_negatively?(question)
    answers.to(question).recent.negative.exists?
  end

  def recently_answered_positively?(question)
    answers.to(question).recent.positive.exists?
  end

  def most_recent_inquiry
    inquiries.order(created_at: :desc).first
  end

  def processing_search_lead
    search_leads.processing.first
  end
end
