require 'rails_helper'

RSpec.describe CardsHelper, :type => :helper do
  let(:card) { FactoryGirl.create(:card) }

  describe "#edit_card_link" do
    it "returns a link to edit the specific card" do
      expect(helper.edit_card_link(card)).to match(card_path(card))
    end
  end

  describe "#delete_card_link" do
    it "returns a link to delete the specific card" do
      expect(helper.delete_card_link(card)).to match(card_path(card))
    end

    it "returns a link with the 'delete' method" do
      expect(helper.delete_card_link(card)).to match(/data-method="delete"/)
    end
  end

  describe "#update_card_status_link" do
    it "returns a link to update the specific card" do
      expect(helper.update_card_status_link(card)).to match(update_status_card_path(card))
    end

    it "should say 'Disable' if the card is currently enabled" do
      card.disabled = false
      expect(helper.update_card_status_link(card)).to match(/Disable/)
    end

    it "should say 'Enable' if the card is currently disabled" do
      card.disabled = true
      expect(helper.update_card_status_link(card)).to match(/Enable/)
    end
  end

  describe "#board_name" do
    pending
  end

  describe "#list_name" do
    pending
  end

  describe "#card_frequency_text" do
    it "returns 'Daily' if the card is daily" do
      card = FactoryGirl.build(:card)
      expect(helper.card_frequency_text(card)).to eq("Daily")
    end

    it "returns the day of the week if the card is weekly" do
      card = FactoryGirl.build(:card, :weekly, frequency_period: 6)
      expect(helper.card_frequency_text(card)).to eq("Every Saturday")
    end

    it "returns the day of the month ordinalized if the card is monthly" do
      card = FactoryGirl.build(:card, :monthly, frequency_period: 10)
      expect(helper.card_frequency_text(card)).to eq("Every month on the 10th")
    end
  end
end
