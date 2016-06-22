require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'card.create_pending_trello_cards', at: '00:01') { Card.create_pending_trello_cards }
end
