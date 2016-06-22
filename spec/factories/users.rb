FactoryGirl.define do
  factory :user do
    provider 'trello'
    uid 'trello-special-uid'
    full_name 'Dennis Martinez'
    nickname 'dennmart'
    oauth_token 'trello-token'

    trait :admin do
      admin true
    end
  end
end
