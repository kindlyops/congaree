# frozen_string_literal: true
class UnknownMessageHandlerJob < ApplicationJob
  def perform(sender, message_sid)
    UnknownMessageHandler.call(sender, message_sid)
  end
end
