class MessagesController < ApplicationController
  decorates_assigned :message, :messages, :user

  def index
    @messages = scoped_messages.order(sent_at: :desc).page(params.fetch(:page, 1))

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def new
    message = scoped_messages.build

    @message = authorize message

    respond_to do |format|
      format.js {}
    end
  end

  def create
    if authorize created_message
      @message = created_message
      @message.create_activity key: 'message.create', owner: message_user
      redirect_to user_messages_url(message_user), notice: "Message sent!"
    else
      redirect_to user_messages_url(message_user), notice: "Unable to send message!"
    end
  end

  private

  def created_message
    @created_message ||= message_user.receive_message(body: params[:message][:body])
  end

  def scoped_messages
    policy_scope(Message).where(user: message_user)
  end

  def message_user
    @user ||= begin
      message_user = User.find(params[:user_id])
      if UserPolicy.new(current_account, message_user).show?
        message_user
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end
end
