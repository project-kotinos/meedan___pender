class PenderWorker
  include Sidekiq::Worker
  include MediasHelper

  def my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/my.log")
  end

  def perform(base_url, url, id)
    my_logger.info("Performing the job")
    take_screenshot(base_url, url, id)
    my_logger.info("After taking screenshot")
  end
end
