class CandidateProfileFeature < ActiveRecord::Base
  belongs_to :candidate_profile
  belongs_to :ideal_feature
  has_many :inquiries

  delegate :name, to: :ideal_feature, prefix: true
  delegate :format, to: :ideal_feature
  delegate :candidate, to: :candidate_profile
  delegate :user, to: :candidate

  def inquire
    message = candidate.receive_message(body: ideal_feature.question)
    inquiries.create(user: user, message_attributes: { sid: message.sid, direction: message.direction, body: message.body })
  end

  def child_class
    properties['child_class'] || "candidate_profile_feature"
  end
end
