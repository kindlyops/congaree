class Question::Experience < Question::MultipleChoice
  def question
    'How many years of private duty or home-care experience do you have?'
  end

  def choices
    {
      a: '0 - 1',
      b: '1 - 5',
      c: '6 or more',
      d: "I'm new to caregiving"
    }
  end

  def inquiry
    :experience
  end

  def answer
    Answer::Experience.new(self)
  end
end
