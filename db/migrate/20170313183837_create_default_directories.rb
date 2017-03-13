class CreateDefaultDirectories < ActiveRecord::Migration
  def change
    path = File.join(Rails.root, 'public', 'screenshots')
    FileUtils.mkdir_p(path) unless File.exists?(path)
  end
end
