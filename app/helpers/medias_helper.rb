module MediasHelper

  def embed_url
    src = @request.original_url.sub(/medias([^\?]*)/, 'medias.js')
    "<script src=\"#{src}\" type=\"text/javascript\"></script>".html_safe
  end

  # TODO Check if it's better to mantain the old address to pictures (without folder
  #  path = self.url.parameterize + '.png'
  #  output_file = File.join(Rails.root, 'public', 'screenshots', path)
  def take_screenshot(base_url, url, id)
    time = Time.now.to_formatted_s(:number)
    path = id + '/' + time + '_' + url.parameterize + '.png'
    output_file = File.join(Rails.root, 'public', 'screenshots', path)
    fetcher = Smartshot::Screenshot.new(window_size: [800, 600])
    begin
      if fetcher.take_screenshot! url: url, output: output_file, wait_for_element: ['body'], sleep: 10, frames_path: []
        screenshot = URI.join(base_url, 'screenshots/', path).to_s
        start_watching(base_url, url, id)
      end
    rescue
      start_watching(base_url, url, id)
    end
    screenshot
  end

  def job_name(id)
    "screenshot-#{id}-job"
  end

  def start_watching(base_url, url, id)
    Sidekiq::Cron::Job.create(name: self.job_name(id), cron: '*/1 * * * *', klass: 'PenderWorker', args: [base_url, url, id], queue: 'high')
  end

end
