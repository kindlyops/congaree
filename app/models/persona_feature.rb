class PersonaFeature < ApplicationRecord
  belongs_to :candidate_persona
  belongs_to :category
  has_many :inquiries

  validates :format, inclusion: { in: %w(document address choice) }

  def question
    questions[format.to_sym]
  end

  def inquire(user)
    message = user.receive_message(body: question)
    inquiries.create(message: message)
  end

  private

  def choice_options_list
    properties['choice_options'].each_with_object("") do |(letter, option), result|
      result << "#{letter}) #{option}\n"
    end
  end

  def choice_options_letters
    properties['choice_options'].keys.to_sentence(last_word_connector: ", or ", two_words_connector: " or ")
  end

  def choice_template
    return "" unless properties['choice_options'].present?
    <<-template
#{name}

#{choice_options_list}

Please reply with just the letter #{choice_options_letters}.
template
  end

  def questions
    {
      document: "Please send a photo of your #{name}",
      address: "What is your street address and zipcode?",
      choice: choice_template
    }
  end
end
