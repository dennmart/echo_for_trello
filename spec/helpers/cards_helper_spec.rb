require 'rails_helper'

RSpec.describe CardsHelper, :type => :helper do
  let(:card) { FactoryGirl.create(:card) }

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
end
