require 'rails_helper'
RSpec.describe CreateTrelloCardWorker, :type => :worker do
  describe "#perform" do
    let(:user) { FactoryGirl.create(:user) }
    let(:card) { FactoryGirl.create(:card, user: user) }
    let(:endpoint) { "#{TrelloApi.base_uri}/lists/#{card.trello_list_id}/cards?key=#{ENV['TRELLO_KEY']}&token=#{user.oauth_token}" }
    let(:api_params) { { name: card.title, desc: card.description, due: '' } }

    before(:each) do
      stub_request(:post, endpoint).with(body: hash_including(api_params))
    end

    context "on success" do
      let(:trello_api_response) { double(success?: true) }

      it "creates a card via the Trello API" do
        expect_any_instance_of(TrelloApi).to receive(:create_card).with(card.trello_list_id, card.trello_api_parameters).and_return(trello_api_response)
        CreateTrelloCardWorker.new.perform(user.id, card.id)
      end

      it "enqueues a job to update the card's position if the position field is present" do
        card.update_attribute(:position, "top")
        allow(trello_api_response).to receive(:[]).with("id").and_return("trello-card-id")
        allow_any_instance_of(TrelloApi).to receive(:create_card).and_return(trello_api_response)
        expect(UpdateCardPositionWorker).to receive(:perform_async).with(user.id, card.id, "trello-card-id")
        CreateTrelloCardWorker.new.perform(user.id, card.id)
      end

      it "does not enqueue a job to update the card's position if the position field is not present" do
        card.update_attribute(:position, nil)
        allow_any_instance_of(TrelloApi).to receive(:create_card).and_return(trello_api_response)
        expect(UpdateCardPositionWorker).to_not receive(:perform_async)
        CreateTrelloCardWorker.new.perform(user.id, card.id)
      end

      it "creates a successful log entry if the API response is successful" do
        allow_any_instance_of(TrelloApi).to receive(:create_card).and_return(trello_api_response)

        expect {
          CreateTrelloCardWorker.new.perform(user.id, card.id)
        }.to change(CardLog, :count).by(1)

        card_log = CardLog.last
        expect(card_log.card).to eq(card)
        expect(card_log.user).to eq(user)
        expect(card_log.successful).to eq(true)
        expect(card_log.message).to be_nil
      end

      it "clears the number of failed attempts for the card" do
        allow_any_instance_of(TrelloApi).to receive(:create_card).and_return(trello_api_response)

        card.update(failed_attempts: 2)

        expect {
          CreateTrelloCardWorker.new.perform(user.id, card.id)
          card.reload
        }.to change(card, :failed_attempts).from(2).to(0)
      end
    end

    context "on failure" do
      let(:trello_api_response) { double(success?: false, code: 401, message: "Unauthorized", body: "invalid token\n") }

      it "creates an unsuccessful log entry with the error message if the API response is not successful" do
        allow_any_instance_of(TrelloApi).to receive(:create_card).and_return(trello_api_response)

        expect {
          CreateTrelloCardWorker.new.perform(user.id, card.id)
        }.to change(CardLog, :count).by(1)

        card_log = CardLog.last
        expect(card_log.card).to eq(card)
        expect(card_log.user).to eq(user)
        expect(card_log.successful).to eq(false)
        expect(card_log.message).to eq("401 Unauthorized - invalid token")
      end

      it "increments the number of failed attempts for the card" do
        allow_any_instance_of(TrelloApi).to receive(:create_card).and_return(trello_api_response)

        expect {
          CreateTrelloCardWorker.new.perform(user.id, card.id)
          card.reload
        }.to change(card, :failed_attempts).from(0).to(1)
      end
    end
  end
end
