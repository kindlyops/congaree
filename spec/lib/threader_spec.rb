require 'rails_helper'

RSpec.describe Threader do
  describe '#call' do
    let(:user) { create(:user) }

    context 'with messages created after the message passed in' do
      let!(:message) { create(:message, user: user, created_at: 5.days.ago) }
      let!(:next_message) { create(:message, user: user, created_at: 4.days.ago) }
      let!(:another_message) { create(:message, user: user, created_at: 3.days.ago) }

      it 'sets the child on the passed in message' do
        expect {
          Threader.new(message).call
        }.to change { message.child }.from(nil).to(next_message)
      end
    end
  end

  describe '.thread' do
    let(:user) { create(:user) }
    let(:messages) { user.messages.by_recency }

    context 'with a user with multiple messages' do
      let!(:oldest) { create(:message, user: user, created_at: 4.days.ago) }
      let!(:second_oldest) { create(:message, user: user, created_at: 3.days.ago) }
      let!(:third_oldest) { create(:message, user: user, created_at: 2.days.ago) }
      let!(:fourth_oldest) { create(:message, user: user, created_at: 1.day.ago) }

      it 'threads appropriately' do
        Threader.thread

        expect(oldest.reload.child).to eq(second_oldest)
        expect(second_oldest.reload.child).to eq(third_oldest)
        expect(third_oldest.reload.child).to eq(fourth_oldest)
        expect(fourth_oldest.reload.child).to eq(nil)
      end

      context 'with messages created at the same time' do
        let!(:second_oldest) { create(:message, user: user, created_at: oldest.created_at) }
        let!(:third_oldest) { create(:message, user: user, created_at: oldest.created_at) }
        let!(:fourth_oldest) { create(:message, user: user, created_at: oldest.created_at) }

        it 'threads appropriately' do
          Threader.thread

          expect(oldest.reload.child).to eq(second_oldest)
          expect(second_oldest.reload.child).to eq(third_oldest)
          expect(third_oldest.reload.child).to eq(fourth_oldest)
          expect(fourth_oldest.reload.child).to eq(nil)
        end
      end

      context 'with messages processed in a different order' do
        let(:user2) { create(:user) }
        let(:older_message_processed_second) { create(:message, user: user2, external_created_at: 2.days.ago, body: 'a long time ago,')}
        let(:newer_message_processed_first) { create(:message, user: user2, external_created_at: 1.days.ago, body: 'in a galaxy far...')}
        it 'threads properly' do
          Threader.new(newer_message_processed_first).call
          Threader.new(older_message_processed_second).call
          expect(older_message_processed_second.child).to eq(newer_message_processed_first)
        end
      end
    end
  end
end
