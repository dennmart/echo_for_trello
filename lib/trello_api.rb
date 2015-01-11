class TrelloApi
  include HTTParty
  base_uri 'https://trello.com/1'

  def initialize(token)
    @token = token
    @options = { key: ENV['TRELLO_KEY'], token: @token }
  end

  def boards
    additional_options = { filter: 'members,open,organization', fields: 'name', lists: 'open' }
    self.class.get '/members/me/boards', query: @options.merge(additional_options)
  end
end
