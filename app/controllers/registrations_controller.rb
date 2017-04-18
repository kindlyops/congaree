class RegistrationsController < Devise::RegistrationsController
  before_action :fetch_address, only: :create

  def new
    super do |account|
      account.build_organization
      account.build_person
    end
  end

  def create
    super { |account| Registrar.new(account).register }
  end

  private

  def sign_up_params
    params.require(resource_name).permit(attributes)
  end

  def attributes
    account_attributes
      .push(organization_attributes: organization_attributes_keys)
  end

  def after_sign_up_path_for(*)
    recruiting_ad_path
  end

  def account_attributes
    %i(email password agreed_to_terms).push(person_attributes: %i(name))
  end

  def organization_attributes_keys
    %i(name).push(location_attributes: location_attribute_keys)
  end

  def location_attribute_keys
    %i(full_street_address
       latitude
       longitude
       city
       state
       state_code
       postal_code
       country
       country_code)
  end

  def location_attributes
    organization_attributes[:location_attributes]
  end

  def organization_attributes
    params[:account][:organization_attributes]
  end

  def finder
    @finder ||= AddressFinder.new(location_attributes[:full_street_address])
  end

  def with_rate_limit_protection
    yield
  rescue Geocoder::OverQueryLimitError => e
    Rollbar.debug(e.message)
    flash[:alert] = rate_limit_message
    set_minimum_password_length
    render :new
  end

  def rate_limit_message
    "Sorry but we're a little overloaded right now and can't "\
        'find addresses. Please try again in a few minutes.'
  end

  def fetch_address_message
    "We couldn't find that address. Please provide the"\
            " city, state, and zipcode if you haven't yet."
  end

  def populate_location_attributes
    location_attribute_keys.each do |field|
      location_attributes[field] = finder.send(field)
    end
  end

  def fetch_address
    with_rate_limit_protection do
      build_resource(sign_up_params)

      if finder.found?
        populate_location_attributes
      else
        flash[:alert] = fetch_address_message
        set_minimum_password_length
        render :new
      end
    end
  end
end
