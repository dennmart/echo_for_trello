class CreateTrelloCardWorker
  include Sidekiq::Worker

  def perform(user_id, card_id)
    user = User.find(user_id)
    card = Card.find(card_id)
    trello = TrelloApi.new(user.oauth_token)

    trello_response = trello.create_card(card.trello_list_id, card.trello_api_parameters)
    if trello_response.success?
      card.clear_failed_attempts!
      CardLog.create(card: card, user: user, successful: true)
      UpdateCardPositionWorker.perform_async(user_id, card_id, trello_response["id"]) if card.position.present?
    else
      card.increment_failed_attempts!
      message = "#{trello_response.code} #{trello_response.message} - #{trello_response.body.strip}"
      CardLog.create(card: card, user: user, successful: false, message: message)
    end
  end
end
