class BotMaker::Question::Experience < BotMaker::Question
  def body
    <<~QUESTION.strip
      How many years of professional caregiving experience do you have?
    QUESTION
  end

  def responses_and_tags
    [
     ['0 - 1', '0 - 1 years', "Very cool! Just getting started!"], 
     ['1 - 5', '1 - 5 years', "Very cool! Just hitting your stride!"], 
     ['6 or more', '6+ years', "Very cool! Thank you for your service."], 
     ["I'm new to caregiving! So excited!", "Very cool! I'm excited too!"]
    ]
  end
end
