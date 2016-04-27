require 'rails_helper'

RSpec.describe InquiryScheduler do
  include ActiveSupport::Testing::TimeHelpers

  let(:organization) { create(:organization, :with_owner) }
  let(:account) { organization.accounts.first }
  let(:job) { create(:job, :with_job_question, :with_job_candidate, account: account) }
  let(:job_question) { job.job_questions.first }
  let(:job_candidate) { job.job_candidates.first }

  context "in organization time" do
    around(:each) do |example|
      Time.use_zone(organization.time_zone) { example.run }
    end

    describe "#call" do
      context "continuing the search" do
        let(:second_question) do
          question = create(:question)
          organization.questions << question
          question
        end
        let(:second_job_question) { job.job_questions.create(question: second_question, previous_question: job_question.question) }

        let(:scheduler) { InquiryScheduler.new(job_candidate, second_job_question) }

        it "creates an inquisitor" do
          expect_any_instance_of(Inquisitor).to receive(:call).once
          scheduler.call
        end
      end

      context "starting the search" do
        let(:scheduler) { InquiryScheduler.new(job_candidate, job_question) }

        context "between 10 am and 8 pm today" do
          before(:each) do
            travel_to Time.current.at_beginning_of_day.advance(hours: 12)
          end

          it "creates an inquisitor" do
            expect_any_instance_of(Inquisitor).to receive(:call).once
            scheduler.call
          end
        end

        context "before 10 am today" do
          before(:each) do
            travel_to Time.current.at_beginning_of_day.advance(hours: 6)
          end

          it "does not create an inquisitor" do
            expect(Inquisitor).not_to receive(:new)
            scheduler.call
          end

          it "creates a job to be performed after 10 am today" do
            ten_am = Time.current.at_beginning_of_day.advance(hours: 10)
            expect(InquisitorJob).to receive(:set).with(wait_until: ten_am + 1.minute).and_call_original

            scheduler.call
          end
        end

        context "after 8 pm today" do
          before(:each) do
            travel_to Time.current.at_beginning_of_day.advance(hours: 22)
          end

          it "does not create an inquisitor" do
            expect(Inquisitor).not_to receive(:new)
            scheduler.call
          end

          it "creates a job to be performed after 10 am tomorrow" do
            ten_am = Time.current.at_beginning_of_day.advance(hours: 10)
            expect(InquisitorJob).to receive(:set).with(wait_until: ten_am.tomorrow + 1.minute).and_call_original

            scheduler.call
          end
        end
      end
    end
  end
end
