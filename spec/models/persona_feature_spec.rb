require 'rails_helper'

RSpec.describe PersonaFeature, type: :model do

  let(:candidate) { create(:candidate) }
  let(:candidate_persona) { candidate.organization.candidate_persona }
  let(:persona_feature) { create(:persona_feature, candidate_persona: candidate_persona) }

  describe "#inquire" do
    it "creates a message" do
      expect{
        persona_feature.inquire(candidate.user)
      }.to change{Message.count}.by(1)
    end

    it "creates an inquiry" do
      expect{
        persona_feature.inquire(candidate.user)
      }.to change{persona_feature.inquiries.count}.by(1)
    end
  end


  describe "#question" do
    context "document" do
      let(:document_persona_feature) { create(:persona_feature, candidate_persona: candidate_persona, format: :document) }
      it "returns a question for the format" do
        expect(document_persona_feature.question).to eq("Please send a photo of your #{document_persona_feature.name}")
      end
    end

    context "address" do
      let(:address_persona_feature) { create(:persona_feature, candidate_persona: candidate_persona, format: :address) }
      it "returns a question for the format" do
        expect(address_persona_feature.question).to eq("What is your street address and zipcode?")
      end
    end

    context "choice" do
      let(:choice_persona_feature) { create(:persona_feature, :choice, candidate_persona: candidate_persona) }
      let(:question) do
        <<-question
What is your availability?

a) Live-in
b) Hourly
c) Both


Please reply with just the letter a, b, or c.
question
      end

      it "returns a question for the format" do
        expect(choice_persona_feature.question).to eq(question)
      end
    end
  end
end
