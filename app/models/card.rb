class Card < ActiveRecord::Base
  FREQUENCY = { 'Daily': 1, 'Weekly': 2, 'Monthly': 3 }

  validates :title, :trello_board_id, :trello_list_id, :frequency, :frequency_period, presence: true
  validates :frequency, exclusion: FREQUENCY.values
end
