class MessagesChannel < ApplicationCable::Channel
  def subscribed
    contact = contacts.find(params[:contact_id])
    stream_for contact
  end

  private

  delegate :contacts, to: :current_organization
end
