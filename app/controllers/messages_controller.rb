class MessagesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :message_not_authorized
  layout 'messages', only: 'index'
  decorates_assigned :conversation

  before_action :ensure_contacts, only: :index

  def index
    @conversations = policy_scope(Conversation)

    redirect_to message_path(current_conversation.contact)
  end

  def show
    @conversation = authorize fetch_conversation, :show?
    conversation.read_receipts.unread.each(&method(:read)) unless impersonating?
    conversation.update(last_viewed_at: DateTime.current)
  end

  def create
    @conversation = authorize fetch_conversation, :show?
    @message = scoped_messages.build
    create_message if authorize @message

    head :ok
  end

  private

  def current_conversation
    current_account.conversations.recently_viewed.first
  end

  def read(receipt)
    receipt.update(read_at: DateTime.current)
  end

  def ensure_contacts
    no_contacts_message if current_account.contacts.empty?
  end

  def no_contacts_message
    flash[:notice] = 'No caregivers to message yet.'
    redirect_to root_path
  end

  def create_message
    current_organization.message(
      sender: current_account.person,
      recipient: @conversation.person,
      body: body
    )
  end

  def body
    params[:message][:body]
  end

  def scoped_messages
    policy_scope(Message).where(
      recipient: @conversation.person,
      sender: current_account.person,
      organization: current_organization
    )
  end

  def fetch_conversation
    current_account.conversations.find_by(contact: contact)
  end

  def contact
    @contact ||= Contact.find(params[:contact_id])
  end

  def message_not_authorized
    redirect_to message_path(contact), alert: error_message
  end

  def error_message
    "Unfortunately #{@conversation.person_handle} has unsubscribed! You can't "\
    'text them using ChirpyHire.'
  end
end
