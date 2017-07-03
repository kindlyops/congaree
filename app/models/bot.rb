class Bot < ApplicationRecord
  belongs_to :organization
  belongs_to :person
  belongs_to :last_edited_by, optional: true, class_name: 'Account'

  has_one :greeting
  has_many :questions
  has_many :goals

  has_many :bot_campaigns
  has_many :inboxes, through: :bot_campaigns
  has_many :campaigns, through: :bot_campaigns

  def receive(message)
    Bot::Receiver.call(self, message)
  end

  def activated?(message)
    Bot::Keyword.new(self, message).activated?
  end

  def greet(message, campaign_contact)
    Bot::Greet.call(self, message, campaign_contact)
  end

  def question_after(question)
    questions.find_by(rank: question.rank + 1)
  end

  def first_question
    questions.order(:rank).first
  end
end
