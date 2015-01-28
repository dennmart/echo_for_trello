class CardLog < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  belongs_to :card
  belongs_to :user
end
