class Bot::FollowUpTrigger
  def self.call(follow_up, message, campaign_contact)
    new(follow_up, message, campaign_contact)
  end

  def initialize(follow_up, message, campaign_contact)
    @follow_up = follow_up
    @message = message
    @campaign_contact = campaign_contact
  end

  def call
    return '' unless follow_up.activated?(message)

    tag_and_broadcast
    next_step_body
  end

  def next_step_body
    "#{follow_up.body}\n\n#{next_step.body}"
  end

  def next_step
    return trigger_next_question if follow_up.next_question?
    return trigger_goal if follow_up.goal?

    trigger_question
  end

  def trigger_goal
    return null_step if goal.blank?
    goal.trigger(message, campaign_contact)
  end

  def trigger_question
    return null_step if question.blank?
    question.trigger(message, campaign_contact)
  end

  def trigger_next_question
    return null_step if next_question.blank?
    next_question.trigger(message, campaign_contact)
  end

  def next_question
    bot.question_after(campaign_contact.question)
  end

  attr_reader :follow_up, :message, :campaign_contact
  delegate :bot, :question, :goal, to: :follow_up
  delegate :contact, to: :campaign_contact

  private

  def tag_and_broadcast
    follow_up.tag(contact)
    Broadcaster::Contact.broadcast(contact)
  end

  def null_step
    OpenStruct.new(body: '')
  end
end
