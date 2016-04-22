class SendAnalyticsEventWorker
  include Sidekiq::Worker

  def perform(event_data)
    # Stub all results if this is not production so they
    # aren't sent to the server during development / testing.
    analytics = Segment::Analytics.new({
      write_key: ENV["ECHO_TRELLO_SEGMENT_WRITE_KEY"],
      stub: !Rails.env.production?
    })

    analytics.track(event_data)
  end
end
