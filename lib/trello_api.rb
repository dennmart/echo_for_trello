class TrelloApi
  include HTTParty
  base_uri 'https://trello.com/1'

  def initialize(token)
    @token = token
    @options = { key: ENV['TRELLO_KEY'], token: @token }
  end

  def boards(options = {})
    trello_options = { filter: 'members,open,organization' }.merge(options)
    self.class.get '/members/me/boards', query: @options.merge(trello_options)
  end

  def board(board_id, options = {})
    self.class.get "/boards/#{board_id}", query: @options.merge(options)
  end
end
