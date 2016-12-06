class PenderWorker
  include Sidekiq::Worker
  include MediasHelper

  def perform(base_url, url, folder)
    take_screenshot(base_url, url, folder)
  end
end
