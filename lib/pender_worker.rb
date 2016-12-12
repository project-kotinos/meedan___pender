class PenderWorker
  include Sidekiq::Worker
  include MediasHelper

  def perform(base_url, url, id)
    take_screenshot(base_url, url, id)
  end
end
