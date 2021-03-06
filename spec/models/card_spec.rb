require 'rails_helper'

RSpec.describe Card, :type => :model do
  context "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:trello_board_id) }
    it { should validate_presence_of(:trello_list_id) }
    it { should validate_presence_of(:frequency) }
    it { should validate_inclusion_of(:frequency).in_array(Card::FREQUENCY.values) }

    it "does not need :frequency_period if the frequency is 'Daily'" do
      card = FactoryGirl.build(:card, frequency: Card::FREQUENCY['Daily'], frequency_period: nil)
      expect(card).to be_valid
    end

    it "validates the presence of :frequency_period if the frequency is 'Weekly'" do
      card = FactoryGirl.build(:card, frequency: Card::FREQUENCY['Weekly'], frequency_period: nil)
      expect(card).to_not be_valid
      card.frequency_period = 1
      expect(card).to be_valid
    end

    it "validates the presence of :frequency_period if the frequency is 'Monthly'" do
      card = FactoryGirl.build(:card, frequency: Card::FREQUENCY['Monthly'], frequency_period: nil)
      expect(card).to_not be_valid
      card.frequency_period = 1
      expect(card).to be_valid
    end

    it "does not need :frequency_period if the frequency is 'Weekdays'" do
      card = FactoryGirl.build(:card, frequency: Card::FREQUENCY['Weekdays'], frequency_period: nil)
      expect(card).to be_valid
    end

    it "does not need :frequency_period if the frequency is 'Weekends'" do
      card = FactoryGirl.build(:card, frequency: Card::FREQUENCY['Weekends'], frequency_period: nil)
      expect(card).to be_valid
    end
  end

  describe "callbacks" do
    context "#track_card_creation_event" do
      let(:user) { FactoryGirl.create(:user) }

      it "enqueues a job to send card information to our analytics" do
        expect(SendAnalyticsEventWorker).to receive(:perform_async).with(event: "Card created", user_id: user.id, properties: { frequency: "Weekdays" })
        FactoryGirl.create(:card, :weekdays, user: user)
      end

      it "adds a frequency_period property to the job if it's set on the card" do
        expect(SendAnalyticsEventWorker).to receive(:perform_async).with(hash_including(properties: { frequency: "Weekly", frequency_period: 4 }))
        FactoryGirl.create(:card, :weekly, frequency_period: 4)
      end

      it "only enqueues the job on creation" do
        card = FactoryGirl.create(:card, :weekdays)
        expect(SendAnalyticsEventWorker).to_not receive(:perform_async)
        card.update_attributes(title: "New title")
      end
    end
  end

  describe "#trello_api_parameters" do
    it "returns the necessary parameters for creating a card through the Trello API" do
      card = FactoryGirl.build(:card, title: "Trello Card", description: "Echo for Trello is awesome!")
      api_params = card.trello_api_parameters
      expect(api_params[:name]).to eq("Trello Card")
      expect(api_params[:desc]).to eq("Echo for Trello is awesome!")
      expect(api_params[:due]).to be_nil
    end
  end

  describe "#set_next_run" do
    before(:each) do
      Timecop.freeze(Time.new(2015, 1, 21, 12, 0, 0)) # Wednesday
    end

    after(:each) do
      Timecop.return
    end

    context "for daily cards" do
      it "sets the next run to the next day if the frequency period is daily" do
        card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Daily'])
        card.set_next_run
        expect(card.next_run.day).to eq(22)
      end
    end

    context "for weekly cards" do
      it "sets the next run to the day of the selected weekday for the same week" do
        card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Weekly'], frequency_period: Date::DAYNAMES.index("Saturday"))
        card.set_next_run
        expect(card.next_run.wday).to eq(Date::DAYNAMES.index("Saturday"))
        expect(card.next_run.day).to eq(24)
      end

      it "sets the next run to the day of the selected weekday for the next week if the weekday already passed" do
        card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Weekly'], frequency_period: Date::DAYNAMES.index("Monday"))
        card.set_next_run
        expect(card.next_run.wday).to eq(Date::DAYNAMES.index("Monday"))
        expect(card.next_run.day).to eq(26)
      end

      it "properly sets the next run for the following day if set_next_run is run on the same day" do
        card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Weekly'], frequency_period: Date::DAYNAMES.index("Wednesday"))
        card.set_next_run
        expect(card.next_run.wday).to eq(Date::DAYNAMES.index("Wednesday"))
        expect(card.next_run.day).to eq(28)
      end
    end

    context "for monthly cards" do
      it "sets the next run to the selected day of this month if the day has not passed" do
        card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Monthly'], frequency_period: 28)
        card.set_next_run
        expect(card.next_run.month).to eq(1)
        expect(card.next_run.day).to eq(28)
      end

      it "sets the next run to the selected day of the next month if the day has already passed" do
        card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Monthly'], frequency_period: 5)
        card.set_next_run
        expect(card.next_run.month).to eq(2)
        expect(card.next_run.day).to eq(5)
      end

      it "sets the next run to the last day of the month if the selected day is greater than the last day of the month" do
        Timecop.freeze(Time.new(2015, 1, 31, 12, 0, 0)) do
          card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Monthly'], frequency_period: 30)
          card.set_next_run
          expect(card.next_run.month).to eq(2)
          expect(card.next_run.day).to eq(28)
        end
      end
    end

    context "for weekday cards" do
      it "sets the next run to the next day if the next day is a weekday" do
        # January 28, 2015 == Wednesday
        Timecop.freeze(Time.new(2015, 1, 28, 12, 0, 0)) do
          card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Weekdays'])
          card.set_next_run
          expect(card.next_run.wday).to eq(Date::DAYNAMES.index("Thursday"))
          expect(card.next_run.day).to eq(29)
        end
      end

      it "sets the next run to the following Monday if the next day is a weekend" do
        # January 23, 2015 == Friday
        Timecop.freeze(Time.new(2015, 1, 23, 12, 0, 0)) do
          card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Weekdays'])
          card.set_next_run
          expect(card.next_run.wday).to eq(Date::DAYNAMES.index("Monday"))
          expect(card.next_run.day).to eq(26)
        end
      end
    end

    context "for weekend cards" do
      it "sets the next run to the next day if the next day is a weekend" do
        # January 24, 2015 == Saturday
        Timecop.freeze(Time.new(2015, 1, 24, 12, 0, 0)) do
          card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Weekends'])
          card.set_next_run
          expect(card.next_run.wday).to eq(Date::DAYNAMES.index("Sunday"))
          expect(card.next_run.day).to eq(25)
        end
      end

      it "sets the next run to the following Saturday if the next day is a weekday" do
        # January 25, 2015 == Sunday
        Timecop.freeze(Time.new(2015, 1, 25, 12, 0, 0)) do
          card = FactoryGirl.create(:card, frequency: Card::FREQUENCY['Weekends'])
          card.set_next_run
          expect(card.next_run.wday).to eq(Date::DAYNAMES.index("Saturday"))
          expect(card.next_run.day).to eq(31)
        end
      end
    end
  end

  describe "#daily?" do
    it "returns true if the card frequency is daily" do
      card = FactoryGirl.build(:card)
      expect(card.daily?).to be_truthy
    end

    it "returns false if the card frequency is not daily" do
      card = FactoryGirl.build(:card, :weekly)
      expect(card.daily?).to be_falsey
    end
  end

  describe "#weekly?" do
    it "returns true if the card frequency is weekly" do
      card = FactoryGirl.build(:card, :weekly)
      expect(card.weekly?).to be_truthy
    end

    it "returns false if the card frequency is not weekly" do
      card = FactoryGirl.build(:card)
      expect(card.weekly?).to be_falsey
    end
  end

  describe "#monthly?" do
    it "returns true if the card frequency is monthly" do
      card = FactoryGirl.build(:card, :monthly)
      expect(card.monthly?).to be_truthy
    end

    it "returns false if the card frequency is not monthly" do
      card = FactoryGirl.build(:card, :weekly)
      expect(card.monthly?).to be_falsey
    end
  end

  describe "#disable!" do
    let!(:card) { FactoryGirl.create(:card, next_run: 1.day.from_now) }

    it "sets the `disabled` field to true" do
      expect {
        card.disable!
      }.to change(card, :disabled).from(false).to(true)
    end

    it "sets the `next_run` field to nil" do
      expect {
        card.disable!
      }.to change(card, :next_run).to(nil)
    end
  end

  describe "#clear_failed_attempts!" do
    it "resets the failed_attempts counter to zero" do
      card = FactoryGirl.create(:card, failed_attempts: 2)

      expect {
        card.clear_failed_attempts!
      }.to change(card, :failed_attempts).from(2).to(0)
    end
  end

  describe "#increment_failed_attempts!" do
    it "increments the failed_attempts counter" do
      card = FactoryGirl.create(:card, failed_attempts: 1)

      expect {
        card.increment_failed_attempts!
      }.to change(card, :failed_attempts).from(1).to(2)
    end
  end

  describe ".create_pending_trello_cards" do
    before(:all) do
      Timecop.freeze
    end

    after(:all) do
      Timecop.return
    end

    before(:each) do
      allow(Snitcher).to receive(:snitch)
    end

    it "finds all cards where next_run is due and calls the async task to create the cards" do
      card_1 = FactoryGirl.create(:card, next_run: 1.hour.ago)
      card_2 = FactoryGirl.create(:card, next_run: 30.minutes.ago)
      card_3 = FactoryGirl.create(:card, next_run: 1.day.from_now)

      expect(CreateTrelloCardWorker).to receive(:perform_async).with(card_1.user_id, card_1.id)
      expect(CreateTrelloCardWorker).to receive(:perform_async).with(card_2.user_id, card_2.id)
      expect(CreateTrelloCardWorker).to_not receive(:perform_async).with(card_3.user_id, card_3.id)
      Card.create_pending_trello_cards
    end

    it "does not call the async task to create a card if the card is disabled" do
      card = FactoryGirl.create(:card, next_run: 1.hour.ago, disabled: true)
      expect(CreateTrelloCardWorker).to_not receive(:perform_async).with(card.user_id, card.id)
      Card.create_pending_trello_cards
    end

    it "pings Dead Man's Snitch" do
      expect(Snitcher).to receive(:snitch)
      Card.create_pending_trello_cards
    end
  end
end
