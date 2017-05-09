require 'rails_helper'

RSpec.describe Answer::Certification do
  let(:contact) { create(:contact) }
  let(:question) { Question::Certification.new(contact) }
  subject { Answer::Certification.new(question) }

  describe '#valid?' do
    ['pca', 'cna', 'other', 'no', 'nah', 'nope', 'Yes, PCA', 'A PCA',
     'pca', 'A)', 'A.', "A\nJazz", "A.\nJazz", 'other', 'ma', 'hha',
     'lpn', 'rn', 'rca', 'C... MA and HHA', 'D just certificate'].each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is true' do
          expect(subject.valid?(message)).to eq(true)
        end
      end
    end

    %w(rcabdef another bother notoreity yarn).each do |body|
      context body do
        let(:message) { create(:message, body: body) }

        it 'is false' do
          expect(subject.valid?(message)).to eq(false)
        end
      end
    end
  end

  describe '#attribute' do
    context 'pca' do
      ['Yes, PCA', 'D PCA', 'pca', 'D)', 'D.',
       "D\nJazz", "D.\nJazz"].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is pca' do
          expect(subject.attribute(message)[:certification]).to eq(:pca)
        end
      end
    end

    context 'cna' do
      ['Yes, CNA', 'A CNA', 'cna', 'A)', 'A.',
       "A\nJazz", "A.\nJazz"].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is cna' do
          expect(subject.attribute(message)[:certification]).to eq(:cna)
        end
      end
    end

    context 'hha' do
      ['Yes, HHA', 'B HHA', 'hha', 'B)', 'B.',
       "B\nJazz", "B.\nJazz"].each do |body|

        let(:message) { create(:message, body: body) }

        it 'is hha' do
          expect(subject.attribute(message)[:certification]).to eq(:hha)
        end
      end
    end

    context 'other' do
      %w(other ma lpn rn rca).push('Yes, Other (MA, LPN, RN, etc.)').each do |body|
        let(:message) { create(:message, body: body) }

        it 'is other' do
          expect(subject.attribute(message)[:certification]).to eq(:other_certification)
        end
      end
    end

    context 'no' do
      %w(no nope N nah).push('Not Yet', 'Not yet', 'E just certificate').each do |body|
        let(:message) { create(:message, body: body) }

        it 'is no' do
          expect(subject.attribute(message)[:certification]).to eq(:no_certification)
        end
      end
    end
  end
end
