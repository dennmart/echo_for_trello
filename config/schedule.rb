every 1.day, :at => '12:01 am' do
  runner "Card.create_pending_trello_cards"
end
