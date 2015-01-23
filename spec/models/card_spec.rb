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
end
