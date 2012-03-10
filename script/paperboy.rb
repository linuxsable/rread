# PAPERBOY
# WILL CHANGE YOUR LIFE
# HE DELIVERS PAPER
# JUST LIKE IN YOUR RETRO NES DREAMS

# To run:
#   RAILS_ENV=development rails runner script/paperboy.rb run

SLEEP_INTERVAL = 30
SYNC_INTERVAL = 5.minutes

Daemons.run_proc('paperboy.rb') do
  # Setup the log
  log = ActiveSupport::BufferedLogger.new(File.join(Rails.root, "log", "paperboy.log"))
  Rails.logger = log
  ActiveRecord::Base.logger = Logger.new('/dev/null')
  # ActiveRecord::Base.logger = log

  loop {
    blogs = Blog.where("articles_last_syncd_at <= ?", Time.now - SYNC_INTERVAL)
    
    blogs.each { |blog| blog.async_articles }

    Rails.logger.info "Enqueing #{blogs.count} blogs to the BlogSyncer queue."

    sleep(SLEEP_INTERVAL)
  }
end