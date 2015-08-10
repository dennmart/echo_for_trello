require 'rails_helper'

RSpec.describe CardLog, :type => :model do
  describe "default scope" do
    it "orders by descending date of creation" do
      card_log_1 = FactoryGirl.create(:card_log, created_at: 1.week.ago)
      card_log_2 = FactoryGirl.create(:card_log, created_at: 1.hour.ago)
      expect(CardLog.all).to eq([card_log_2, card_log_1])
    end
  end
end
