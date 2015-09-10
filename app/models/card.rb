class Card < ActiveRecord::Base
  FREQUENCY = { 'Daily' => 1, 'Weekly' => 2, 'Monthly' => 3 }

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
    time = Time.now.beginning_of_day

    if frequency == FREQUENCY['Daily']
      update_attribute(:next_run, time.advance(days: 1))
    elsif frequency == FREQUENCY['Weekly']
      if time.wday >= frequency_period
        update_attribute(:next_run, time.next_week + (frequency_period - 1).days)
      else
        update_attribute(:next_run, time + (frequency_period - time.wday).days)
      end
    elsif frequency == FREQUENCY['Monthly']
      if time.day < frequency_period
        update_attribute(:next_run, time.change(day: frequency_period))
      else
        if frequency_period > time.next_month.end_of_month.day
          update_attribute(:next_run, time.next_month.end_of_month.beginning_of_day)
        else
          update_attribute(:next_run, time.next_month.change(day: frequency_period))
        end
      end
    end
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
