class User < ActiveRecord::Base
  has_many :cards
  has_many :card_logs

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)

    if user
      user.update(oauth_token: auth["credentials"]["token"]) if user.oauth_token != auth["credentials"]["token"]
      user.update(email: auth["info"]["email"]) if user.email.blank? || user.email != auth["info"]["email"]
    end

    user
  end

  def next_run_info
    next_run = 1.day.from_now.utc.midnight.in_time_zone(time_zone)
    next_run.strftime("%-l:%M %p (#{time_zone || "UTC"})")
  end
end
