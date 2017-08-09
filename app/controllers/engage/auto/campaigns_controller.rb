class Engage::Auto::CampaignsController < ApplicationController
  def index
    @campaigns = policy_scope(Campaign)
  end

  def show
    @campaign = authorize(campaigns.find(params[:id]))
  end

  def update
    @campaign = authorize(campaigns.find(params[:id]))

    if @campaign.update(permitted_attributes(Campaign))
      redirect_to engage_auto_campaign_path(@campaign), notice: campaign_notice
    else
      render :show
    end
  end

  private

  def campaign_notice
    "#{@campaign.name} saved!"
  end

  delegate :campaigns, to: :current_organization
end
