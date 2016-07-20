class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate
  DEFAULT_FILTER = "Screened"

  def show
    @candidate = authorized_candidate
  end

  def index
    @candidates = scoped_candidates.order(id: :desc).status(status).page(params.fetch(:page, 1))
  end

  def update
    if authorized_candidate.update(permitted_attributes(Candidate))
      redirect_to candidates_url, notice: "Nice! #{authorized_candidate.phone_number.phony_formatted} marked as #{authorized_candidate.status}"
    else
      redirect_to candidates_url, alert: "Oops! Couldn't change the candidate's status"
    end
  end

  private

  def authorized_candidate
    authorize Candidate.find(params[:id])
  end

  def scoped_candidates
    policy_scope(Candidate)
  end

  def status
    status = params[:status]

    if status.present?
      cookies[:candidate_status_filter] = { value: status }
      status
    elsif cookies[:candidate_status_filter].present?
      cookies[:candidate_status_filter]
    else
      cookies[:candidate_status_filter] = { value: DEFAULT_FILTER }
      return DEFAULT_FILTER
    end
  end
end
