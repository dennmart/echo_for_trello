require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.hour, 'card.create_pending_trello_cards', at: '**:01') { Card.create_pending_trello_cards }
end
