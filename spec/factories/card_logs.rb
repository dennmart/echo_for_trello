FactoryGirl.define do
  factory :card_log do
    association :card
    association :user
    successful true

    trait :unsuccessful do
      successful false
      message "Trello Unauthorized"
    end
  end
end
