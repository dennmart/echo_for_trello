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
    let(:boards) { [
      { "id" => 1, "name" => "Board #1" },
      { "id" => 2, "name" => "Board #2" },
      { "id" => 3, "name" => "Board #3" }
    ] }

    it "iterates through the boards and returns the board name matching the specified ID" do
      expect(helper.board_name(boards, 1)).to eq("Board #1")
      expect(helper.board_name(boards, 2)).to eq("Board #2")
      expect(helper.board_name(boards, 3)).to eq("Board #3")
    end

    it "returns '---' if a board cannot be found" do
      expect(helper.board_name(boards, 12345)).to eq("---")
    end
  end

  describe "#list_name" do
    let(:board_1_lists) { [
      { "id" => 1, "name" => "List #1" },
      { "id" => 2, "name" => "List #2" }
    ] }
    let(:board_2_lists) { [
      { "id" => 3, "name" => "List #3" }
    ] }
    let(:boards) { [
      { "id" => 1, "name" => "Board #1", "lists" => board_1_lists },
      { "id" => 2, "name" => "Board #2", "lists" => board_2_lists }
    ] }

    it "iterates through the boards and its lists and returns the list name matching the specified list ID" do
      expect(helper.list_name(boards, 1, 2)).to eq("List #2")
      expect(helper.list_name(boards, 2, 3)).to eq("List #3")
    end

    it "returns '---' if a board cannot be found" do
      expect(helper.list_name(boards, 123, 1)).to eq("---")
    end

    it "returns '---' if a list cannot be found" do
      expect(helper.list_name(boards, 1, 3)).to eq("---")
    end
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

    it "returns 'Monday Through Friday' if the card is generated on weekdays" do
      card = FactoryGirl.build(:card, :weekdays)
      expect(helper.card_frequency_text(card)).to eq("Monday through Friday")
    end

    it "returns 'Saturday and Sunday' if the card is generated on weekends" do
      card = FactoryGirl.build(:card, :weekends)
      expect(helper.card_frequency_text(card)).to eq("Saturday and Sunday")
    end
  end
end
