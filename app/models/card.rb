class Card < ActiveRecord::Base
  FREQUENCY = {
    'Daily'    => 1,
    'Weekly'   => 2,
    'Monthly'  => 3,
    'Weekdays' => 4,
    'Weekends' => 5
  }

  default_scope { order(created_at: :desc) }

  belongs_to :user
  has_many :card_logs

  validates :title, :trello_board_id, :trello_list_id, :frequency, presence: true
  validates :frequency, inclusion: FREQUENCY.values
  validates :frequency_period, presence: true, if: :frequency_needs_period?

  paginates_per 10

  def trello_api_parameters
    # Trello requires the due date in the API call, but we don't use it yet.
    { name: title, desc: description, due: nil }
  end

  def set_next_run
    update_attribute(:next_run, CardNextRun.update_time(self))
  end

  def daily?
    frequency == FREQUENCY['Daily']
  end

  def weekly?
    frequency == FREQUENCY['Weekly']
  end

  def monthly?
    frequency == FREQUENCY['Monthly']
  end

  def weekdays?
    frequency == FREQUENCY['Weekdays']
  end

  def weekends?
    frequency == FREQUENCY['Weekends']
  end

  def disable!
    update_attributes(disabled: true, next_run: nil)
  end

  def self.create_pending_trello_cards
    Card.where(disabled: false).where("next_run <= ?", Time.now).each do |card|
      CreateTrelloCardWorker.perform_async(card.user_id, card.id)
      card.set_next_run
    end
  end

  private

  def frequency_needs_period?
    frequency == FREQUENCY['Weekly'] || frequency == FREQUENCY['Monthly']
  end
end
