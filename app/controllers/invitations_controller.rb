class InvitationsController < Devise::InvitationsController
  before_action :add_accept_params, only: :update
  before_action :add_invite_params, only: :create

  def edit
    set_minimum_password_length
    resource.invitation_token = params[:invitation_token]
    render :edit
  end

  private

  delegate :organization, to: :current_inviter

  def invite_params
    super.merge(organization: organization)
  end

  def after_invite_path_for(*)
    organizations_settings_people_invitation_new_path
  end

  def add_accept_params
    devise_parameter_sanitizer.permit(
      :accept_invitation,
      keys: [:agreed_to_terms, :email, :name]
    )
  end

  def add_invite_params
    devise_parameter_sanitizer.permit(
      :invite,
      keys: [:email, :name]
    )
  end

  def devise_mapping
    Devise.mappings[:account]
  end
end
