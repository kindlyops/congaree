require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:team) { create(:team, :account) }
  let(:organization) { team.organization }
  let(:inviter) { organization.accounts.first }

  let(:invite_params) do
    {
      account: {
        email: 'bob@example.com',
        person_attributes: {
          name: Faker::Name.name
        }
      }
    }
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:account]
  end

  describe '#create' do
    before do
      sign_in(inviter)
    end

    it 'creates the account' do
      expect {
        post :create, params: invite_params
      }.to change { organization.accounts.count }.by(1)
    end

    it 'makes the account invited' do
      post :create, params: invite_params
      expect(Account.last.invited?).to eq(true)
    end

    it 'adds the account to the team' do
      expect {
        post :create, params: invite_params
      }.to change { team.accounts.count }.by(1)
    end

    context 'impersonating' do
      let(:impersonator) { inviter }
      let(:impersonatee) { create(:account, :team) }
      let(:impersonatee_organization) { impersonatee.organization }
      let(:impersonatee_team) { impersonatee.teams.first }
      let(:impersonator_organization) { impersonator.organization }
      let(:impersonator_team) { impersonator.teams.first }

      before do
        impersonator.update(super_admin: true)
        controller.impersonate_account(impersonatee)
      end

      it 'ties the account to the impersonated organization' do
        expect {
          post :create, params: invite_params
        }.to change { impersonatee_organization.accounts.count }.by(1)
      end

      it 'adds the account to the impersonated team' do
        expect {
          post :create, params: invite_params
        }.to change { impersonatee_team.accounts.count }.by(1)
      end

      it 'does not add an account to the impersonator organization' do
        expect {
          post :create, params: invite_params
        }.not_to change { impersonator_organization.accounts.count }
      end

      it 'does not add an account to the impersonator team' do
        expect {
          post :create, params: invite_params
        }.not_to change { impersonator_team.accounts.count }
      end
    end
  end

  describe '#update' do
    let(:email) { 'bob@someemail.com' }

    let(:account_attributes) do
      { email: email, organization: organization, person_attributes: {
        name: Faker::Name.name
      } }
    end

    let!(:account) do
      Account.invite!(account_attributes, inviter)
    end

    let(:invite_params) do
      { account: {
        email: email,
        invitation_token: account.raw_invitation_token,
        password: 'password',
        password_confirmation: 'password',
        agreed_to_terms: true
      } }
    end

    context 'and the role has not been changed' do
      it 'makes the account a member' do
        put :update, params: invite_params
        expect(Account.last.member?).to eq(true)
      end
    end

    context 'and the role is owner' do
      before do
        Account.last.update(role: :owner)
      end

      it 'leaves the role as is' do
        put :update, params: invite_params
        expect(Account.last.owner?).to eq(true)
      end
    end

    it 'agrees to the terms' do
      put :update, params: invite_params
      expect(Account.last.agreed_to_terms?).to eq(true)
    end
  end

  describe '#new' do
    context 'not logged in' do
      it 'does not raise an error' do
        expect {
          get :new
        }.not_to raise_error
      end
    end
  end
end
