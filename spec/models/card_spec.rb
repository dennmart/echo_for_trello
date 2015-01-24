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
  end

  describe "#trello_api_parameters" do
    it "returns the necessary parameters for creating a card through the Trello API" do
      card = FactoryGirl.build(:card, title: "Trello Card", description: "Trello Echo is awesome!")
      api_params = card.trello_api_parameters
      expect(api_params[:name]).to eq("Trello Card")
      expect(api_params[:desc]).to eq("Trello Echo is awesome!")
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
  end
end
