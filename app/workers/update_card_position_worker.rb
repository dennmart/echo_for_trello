class UpdateCardPositionWorker
  include Sidekiq::Worker

  def perform(user_id, card_id, trello_card_id)
    user = User.find(user_id)
    card = Card.find(card_id)
    trello = TrelloApi.new(user.oauth_token)

    return unless card.position.present?
    trello.update_card_position(trello_card_id, card.position)
  end
end
