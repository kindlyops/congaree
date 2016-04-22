class SearchLead < ActiveRecord::Base
  belongs_to :search
  belongs_to :lead

  delegate :organization, to: :lead
  delegate :first_search_question, to: :search

  enum status: [:pending, :processing, :finished]
  enum fit: [:possible_fit, :bad_fit, :good_fit]

  def determine_fit
    return bad_fit! if is_bad_fit?
    return good_fit! if is_good_fit?
    possible_fit!
  end

  private

  def is_good_fit?
    lead.answers.to(search.questions).recent.positive.count == search.questions.count
  end

  def is_bad_fit?
    lead.answers.to(search.questions).recent.negative.exists?
  end
end
