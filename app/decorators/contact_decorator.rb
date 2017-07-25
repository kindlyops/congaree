class ContactDecorator < Draper::Decorator
  delegate_all
  decorates_association :person
  delegate :hero_pattern_classes, :phone_number, to: :person

  def joined_at
    Contact::JoinedAt.new(object)
  end

  def last_active_at
    Contact::LastActiveAt.new(object)
  end

  def candidacy_zipcode
    Contact::ZipCode.new(object)
  end
end
