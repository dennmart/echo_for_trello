require 'rails_helper'
RSpec.describe SendAnalyticsEventWorker, type: :worker do
  describe "#perform" do
    let(:event_data) { { user_id: 12345, event: "Card created" } }
    let(:analytics_double) { double(Segment::Analytics) }

    it "sends the event data hash passed to the method to Segment::Analytics#track" do
      allow(Segment::Analytics).to receive(:new).and_return(analytics_double)
      expect(analytics_double).to receive(:track).with(event_data)
      SendAnalyticsEventWorker.new.perform(event_data)
    end

    it "sets the :stub option to true if the environment is not production" do
      expect(Segment::Analytics).to receive(:new).with(hash_including(stub: true)).and_return(analytics_double)
      allow(analytics_double).to receive(:track).with(event_data)
      SendAnalyticsEventWorker.new.perform(event_data)
    end

    it "sets the :stub option to false if the environment is production" do
      allow(Rails.env).to receive(:production?).and_return(true)
      expect(Segment::Analytics).to receive(:new).with(hash_including(stub: false)).and_return(analytics_double)
      allow(analytics_double).to receive(:track).with(event_data)
      SendAnalyticsEventWorker.new.perform(event_data)
    end
  end
end
