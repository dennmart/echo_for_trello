require 'rails_helper'
RSpec.describe UpdateCardPositionWorker, type: :worker do
  describe "#perform" do
    let(:user) { FactoryGirl.create(:user) }
    let(:card) { FactoryGirl.create(:card, position: "top") }

    it "updates the card's position via the Trello API" do
      expect_any_instance_of(TrelloApi).to receive(:update_card_position).with("trello-card-id", "top")
      UpdateCardPositionWorker.new.perform(user.id, card.id, "trello-card-id")
    end

    it "doesn't call the Trello API if the position is not set" do
      card.update_attribute(:position, nil)
      expect_any_instance_of(TrelloApi).to_not receive(:update_card_position)
      UpdateCardPositionWorker.new.perform(user.id, card.id, "trello-card-id")
    end
  end
end
