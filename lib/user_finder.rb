class UserFinder
  def initialize(organization:, attributes:)
    @organization = organization
    @attributes = attributes
  end

  def call
    user = organization.users.find_by(phone_number: attributes[:phone_number])
    if user.blank?
      user = organization.users.create(attributes)
    end
    user
  end

  private

  attr_reader :attributes, :organization
end
