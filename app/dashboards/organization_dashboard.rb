# frozen_string_literal: true
require 'administrate/base_dashboard'

class OrganizationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    users: Field::HasMany,
    candidates: Field::HasMany,
    referrers: Field::HasMany,
    accounts: Field::HasMany,
    messages: Field::HasMany,
    templates: Field::HasMany,
    rules: Field::HasMany,
    survey: Field::HasOne,
    location: Field::HasOne,
    id: Field::Number,
    name: Field::String,
    twilio_account_sid: Field::String,
    twilio_auth_token: Field::String,
    phone_number: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    time_zone: Field::String,
    onboarding_status: Field::Number
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :users,
    :candidates,
    :referrers,
    :accounts
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :users,
    :candidates,
    :referrers,
    :accounts,
    :messages,
    :templates,
    :rules,
    :survey,
    :location,
    :id,
    :name,
    :twilio_account_sid,
    :twilio_auth_token,
    :phone_number,
    :created_at,
    :updated_at,
    :time_zone,
    :onboarding_status
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :users,
    :candidates,
    :referrers,
    :accounts,
    :messages,
    :templates,
    :rules,
    :survey,
    :location,
    :name,
    :twilio_account_sid,
    :twilio_auth_token,
    :phone_number,
    :time_zone,
    :onboarding_status
  ].freeze

  # Overwrite this method to customize how organizations are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(organization)
  #   "Organization ##{organization.id}"
  # end
end
