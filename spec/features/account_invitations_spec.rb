require 'rails_helper'

RSpec.describe 'Account Invitations', type: :feature, js: true do
  include Features::InvitationHelpers
  let(:account) { create(:account, :team_with_phone_number) }
  let(:team) { account.teams.first }
  let(:organization) { account.organization }
  let(:email) { Faker::Internet.email }
  let(:name) { Faker::Name.name }

  before do
    login_as(account, scope: :account)
  end

  describe 'sending an invitation' do
    it 'notifies the user that the invitation was sent' do
      send_invitation_to(email, name)
      expect(page).to have_text("An invitation email has been sent to #{email}")
    end
  end
end
