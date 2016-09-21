require 'rails_helper'

RSpec.describe StageDefaults do
  describe 'validation' do
    let(:organization1) { create(:organization, :with_subscription, :with_account) }
    let(:organization2) { create(:organization, :with_subscription, :with_account) }

    it "doesn't allow duplicate names within an organization" do
      used_name = organization1.stages.first.name
      stage = organization1.stages.create(name: used_name, order: 10)
      expect(stage.errors).to include(:name)
    end
    it 'does allow duplicate names across organizations' do
      duplicate_name = 'new stage'

      organization1.stages.create(name: duplicate_name, order: 10)
      duplicate_stage_different_org =
        organization2.stages.create(name: duplicate_name, order: 10)

      expect(duplicate_stage_different_org.errors).to be_empty
    end
  end

  describe 'defaults' do
    it 'has four defaults' do
      expect(StageDefaults.defaults.count).to eq(4)
    end
  end
end
