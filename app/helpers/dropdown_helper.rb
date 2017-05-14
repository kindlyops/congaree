module DropdownHelper
  def dropdown_labels
    klasses.map(&:humanize_attributes).inject(&:merge)
  end

  def dropdown_icons
    klasses.map(&:icon_classes).inject(&:merge)
  end

  private

  def klasses
    [Person::Certification, Person::Experience,
     Person::Availability, Person::Transportation]
  end
end
