class Answer::Zipcode < Answer::Base
  def valid?(message)
    zipcode = fetch_zipcode(message)

    zipcode.present? && ZipCodes.identify(zipcode).present?
  end

  def attribute(message)
    { zipcode: fetch_zipcode(message) }
  end

  def format(message)
    super
    after_format(message)
  end

  private

  def after_format(message)
    zipcode_string = fetch_zipcode(message)
    zipcode = ::Zipcode.find_by(zipcode: zipcode_string)

    if zipcode.present?
      message.person.update!(zipcode: zipcode)
    else
      ZipcodeFetcherJob.perform_later(message.person, zipcode_string)
    end
  end

  def existing_zipcode?(message)
    Zipcode.where(zipcode: fetch_zipcode(message)).exists?
  end

  def zipcode_regexp
    /\A(\d{5})\z/
  end

  def fetch_zipcode(message)
    result = zipcode_regexp.match(clean_body(message))
    return unless result.present?

    result[1]
  end

  def clean_body(message)
    message.body.strip.downcase
  end
end
