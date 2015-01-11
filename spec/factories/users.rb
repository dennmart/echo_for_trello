FactoryGirl.define do
  factory :user do
    provider 'trello'
    uid 'trello-special-uid'
    full_name 'Dennis Martinez'
    nickname 'dennmart'
    oauth_token 'trello-token'
  end
end
