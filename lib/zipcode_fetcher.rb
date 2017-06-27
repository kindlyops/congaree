class ZipcodeFetcher
  def self.call(contact, zipcode_string)
    new(contact, zipcode_string).call
  end

  attr_reader :contact, :zipcode_string

  def initialize(contact, zipcode_string)
    @contact = contact
    @zipcode_string = zipcode_string
  end

  def call
    existing_zipcode = Zipcode.find_by(zipcode: zipcode_string)

    if existing_zipcode.present?
      update_zipcode(existing_zipcode)
    else
      lookup.zipcode = zipcode_string
      client.send_lookup(lookup)
      update_zipcode(created_zipcode) if result.zipcodes.present?
    end
  end

  private

  def update_zipcode(zipcode)
    contact.person.update!(zipcode: zipcode)
  end

  def created_zipcode
    @created_zipcode ||= begin
      Zipcode.create!(response_zipcode)
    end
  end

  def zipcode_attributes
    %i[zipcode zipcode_type default_city county_fips county_name
       state_abbreviation state latitude longitude precision]
  end

  def response_zipcode
    @response_zipcode ||= begin
      first = result.zipcodes.first

      Hash[zipcode_attributes.map do |method|
        [method, first.send(method)]
      end]
    end
  end

  def result
    @result ||= lookup.result
  end

  def lookup
    @lookup ||= Smartystreets::USZipcode::Lookup.new
  end

  def auth_id
    ENV.fetch('SMARTY_AUTH_ID')
  end

  def auth_token
    ENV.fetch('SMARTY_AUTH_TOKEN')
  end

  def credentials
    Smartystreets::StaticCredentials.new(auth_id, auth_token)
  end

  def client
    @client ||= Smartystreets::USZipcode::ClientBuilder.new(credentials).build
  end
end
