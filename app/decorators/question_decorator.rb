class QuestionDecorator < Draper::Decorator
  delegate_all

  def title
    "Ask a question"
  end

  def subtitle
    "Asks candidate a screening question via text message."
  end

  def icon_class
    "fa-question"
  end
end
