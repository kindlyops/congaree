require 'rails_helper'

RSpec.describe AutomatonJob do

  let(:user) { create(:user) }
  let(:observable) { create(:question) }
  let(:operation) { "answer" }

  describe "#perform" do
    it "calls the Automaton" do
      expect(Automaton).to receive(:call).with(user, observable, operation)
      AutomatonJob.perform_now(user, observable, operation)
    end
  end
end
