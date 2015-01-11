FactoryGirl.define do
  factory :user do
    provider 'trello'
    uid 'trello-special-uid'
    full_name 'Dennis Martinez'
    nickname 'dennmart'
  end
end
