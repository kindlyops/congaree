module Messaging
  class Message
    def initialize(message)
      @message = message
    end

    def num_media
      message.num_media.to_i
    end

    private

    attr_reader :message

    def method_missing(method, *args, &block)
      message.send(method, *args, &block)
    end
  end
end
