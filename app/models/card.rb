class Card < ActiveRecord::Base
  FREQUENCY = { 'Daily' => 1, 'Weekly' => 2, 'Monthly' => 3 }

  validates :title, :trello_board_id, :trello_list_id, :frequency, presence: true
  validates :frequency, inclusion: FREQUENCY.values
  validates :frequency_period, presence: true, if: :frequency_needs_period?

  def trello_api_parameters
    # Trello requires the due date in the API call, but we don't use it yet.
    { name: title, desc: description, due: nil }
  end

  private

  def frequency_needs_period?
    frequency == FREQUENCY['Weekly'] || frequency == FREQUENCY['Monthly']
  end
end
