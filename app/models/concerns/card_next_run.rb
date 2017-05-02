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

  def weekdays(card)
    if tomorrow.saturday? || tomorrow.sunday?
      time.next_week(:monday)
    else
      time.advance(days: 1)
    end
  end

  def weekends(card)
    if tomorrow.saturday? || tomorrow.sunday?
      time.advance(days: 1)
    else
      time.advance(days: (6 - time.wday))
    end
  end

  private

  def time
    Time.current.beginning_of_day
  end

  def tomorrow
    time + 1.day
  end
end
