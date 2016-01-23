module CardNextRun
  extend self

  def self.update_time(card)
    send(Card::FREQUENCY.invert[card.frequency].downcase, card)
  end

  def daily(card)
    time.advance(days: 1)
  end

  def weekly(card)
    if time.wday >= card.frequency_period
      time.next_week + (card.frequency_period - 1).days
    else
      time + (card.frequency_period - time.wday).days
    end
  end

  def monthly(card)
    if time.day < card.frequency_period
      time.change(day: card.frequency_period)
    else
      if card.frequency_period > time.next_month.end_of_month.day
        time.next_month.end_of_month.beginning_of_day
      else
        time.next_month.change(day: card.frequency_period)
      end
    end
  end

  private

  def time
    Time.now.utc.beginning_of_day
  end
end
