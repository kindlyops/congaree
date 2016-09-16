class SubscriptionsController < ApplicationController
  skip_before_action :block_invalid_subscriptions
  before_action :ensure_new_subscription, only: [:new, :create]

  def new
    @subscription = authorized_subscription
  end

  def edit
    @subscription = authorized_subscription
  end

  def show
    @subscription = authorized_subscription
  end

  def update
    @subscription = authorized_subscription

    if successfully_updated_subscription?
      SurveyAdvancer.call(current_organization)

      redirect_to subscription_path(@subscription), notice: "Nice! Subscription changed."
    else
      render :edit
    end
  end

  def create
    @subscription = authorized_subscription

    if successfully_created_subscription?
      SurveyAdvancer.call(current_organization)

      redirect_to subscription_path(@subscription), notice: "Nice! Subscription created."
    else
      render :new
    end
  end

  def destroy
    @subscription = authorized_subscription
    Payment::Subscriptions::Cancel.call(@subscription)
    redirect_to subscription_path(@subscription), notice: "Sorry to see you go. Your account is canceled."
  end

  private

  def successfully_updated_subscription?
    Payment::Subscriptions::Update.call(@subscription, permitted_attributes(Subscription))
  rescue Payment::CardError => e
    flash[:alert] = e.message
    false
  end

  def successfully_created_subscription?
    Payment::Subscriptions::Process.call(params[:stripe_token], @subscription, current_account.email, permitted_attributes(Subscription))
  rescue Payment::CardError => e
    flash[:alert] = e.message
    false
  end

  def payment_error_message(error)
    <<-ERROR
#{error.message} Need Help? <a href='javascript:void(0)' onclick="Intercom('showNewMessage')">Message Us</a>
    ERROR
  end

  def authorized_subscription
    @authorized_subscription ||= authorize current_organization.subscription
  end

  def ensure_new_subscription
    unless authorized_subscription.trialing? && authorized_subscription.stripe_id.blank?
      redirect_to edit_subscription_path(authorized_subscription)
    end
  end
end
