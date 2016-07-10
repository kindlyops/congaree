require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    organization: Field::BelongsTo,
    candidate: Field::HasOne,
    referrer: Field::HasOne,
    account: Field::HasOne,
    activities: Field::HasMany,
    messages: Field::HasMany,
    inquiries: Field::HasMany,
    answers: Field::HasMany,
    notifications: Field::HasMany,
    chirps: Field::HasMany,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    phone_number: Field::String,
    contact: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :organization,
    :candidate,
    :referrer,
    :account,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :organization,
    :candidate,
    :referrer,
    :account,
    :activities,
    :messages,
    :inquiries,
    :answers,
    :notifications,
    :chirps,
    :id,
    :first_name,
    :last_name,
    :phone_number,
    :contact,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :organization,
    :candidate,
    :referrer,
    :account,
    :activities,
    :messages,
    :inquiries,
    :answers,
    :notifications,
    :chirps,
    :first_name,
    :last_name,
    :phone_number,
    :contact,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end
