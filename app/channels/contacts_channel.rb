class ContactsChannel < ApplicationCable::Channel
  def subscribed
    reject if contact.blank?
    stream_for contact
  end

  delegate :contacts, to: :current_account

  private

  def contact
    @contact ||= contacts.find(params[:id])
  end
end
