FactoryGirl.define do
  factory :card do
    title 'Recurring Card'
    description 'Just another recurring card'
    trello_board_id 'trelloboard123'
    trello_list_id 'trellolist123'
    frequency Card::FREQUENCY['Daily']
    frequency_period 0
  end
end
