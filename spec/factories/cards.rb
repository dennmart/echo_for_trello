FactoryGirl.define do
  factory :card do
    association :user
    title 'Recurring Card'
    description 'Just another recurring card'
    trello_board_id 'trelloboard123'
    trello_list_id 'trellolist123'
    frequency Card::FREQUENCY['Daily']

    trait :weekly do
      frequency Card::FREQUENCY['Weekly']
      frequency_period 0
    end

    trait :monthly do
      frequency Card::FREQUENCY['Monthly']
      frequency_period 1
    end

    trait :weekdays do
      frequency Card::FREQUENCY['Weekdays']
    end

    trait :weekends do
      frequency Card::FREQUENCY['Weekends']
    end
  end
end
