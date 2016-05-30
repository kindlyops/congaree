class Inquiry < ActiveRecord::Base
  belongs_to :candidate_feature
  belongs_to :message
  has_one :answer
  delegate :organization, to: :message
  delegate :feature_format, to: :candidate_feature

  scope :unanswered, -> { includes(:answer).where(answers: { inquiry_id: nil }) }

  def expects?(answer)
    if candidate_feature.document?
      answer.has_images?
    end
  end
end
