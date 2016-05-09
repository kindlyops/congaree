class Message < ActiveRecord::Base
  belongs_to :user
  has_one :notification
  has_one :inquiry
  has_one :answer

  def body
    properties["Body"]
  end

  def media_url
    properties["MediaUrl0"]
  end
end
