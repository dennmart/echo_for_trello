class CreateTrelloCardWorker
  include Sidekiq::Worker

  def perform(user_id, card_id)
    user = User.find(user_id)
    card = Card.find(card_id)
    trello = TrelloApi.new(user.oauth_token)
    trello.create_card(card.trello_list_id, card.trello_api_parameters)
  end
end
