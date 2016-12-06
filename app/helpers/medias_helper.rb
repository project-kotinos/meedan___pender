module MediasHelper

  def embed_url
    src = @request.original_url.sub(/medias([^\?]*)/, 'medias.js')
    "<script src=\"#{src}\" type=\"text/javascript\"></script>".html_safe
  end

  # TODO Check if it's better to mantain the old address to pictures (without folder
  #  path = self.url.parameterize + '.png'
  #  output_file = File.join(Rails.root, 'public', 'screenshots', path)
  def take_screenshot(base_url, url, folder)
    path = folder + '/' + url.parameterize + '.png'
    output_file = File.join(Rails.root, 'public', 'screenshots', folder, path)
    fetcher = Smartshot::Screenshot.new(window_size: [800, 600])
    if fetcher.take_screenshot! url: url, output: output_file, wait_for_element: ['body'], sleep: 10, frames_path: []
      screenshot = URI.join(base_url, 'screenshots/', path).to_s
    end
  end
end
