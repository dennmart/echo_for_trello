class TrelloApi
  include HTTParty
  base_uri 'https://trello.com/1'

  def initialize(token)
    @token = token
    @options = { key: ENV['TRELLO_KEY'], token: @token }
  end

  def boards(options = {})
    trello_options = { filter: 'open' }.merge(options)
    self.class.get '/members/me/boards', query: @options.merge(trello_options)
  end

  def board(board_id, options = {})
    self.class.get "/boards/#{board_id}", query: @options.merge(options)
  end

  def create_list(board_id, list_name)
    self.class.post "/boards/#{board_id}/lists", query: @options, body: { name: list_name }
  end

  def create_card(list_id, card_info)
    self.class.post "/lists/#{list_id}/cards", query: @options, body: card_info
  end

  def update_card_position(card_id, position)
    self.class.put "/cards/#{card_id}/pos", query: @options, body: { value: position }
  end
end
