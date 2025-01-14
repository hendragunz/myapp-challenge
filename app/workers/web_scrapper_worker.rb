class WebScrapperWorker
  include Sidekiq::Job
  include Sidekiq::Throttled::Worker

  sidekiq_throttle(
    concurrency:  { limit: 1 },
    threshold:    { limit: 1, period: 10.second }
  )

  def perform(keyword_id)
    keyword = Keyword.find(keyword_id)
    keyword.scrap_search!
  end
end
