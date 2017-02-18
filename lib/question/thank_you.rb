class Question::ThankYou < Question::Base
  def to_s
    <<~BODY
      Thanks for your interest in #{organization.name}!

      We will give you a call to confirm at our earliest opportunity!
    BODY
  end
end
