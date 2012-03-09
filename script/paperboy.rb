# PAPERBOY
# WILL CHANGE YOUR LIFE
# HE DELIVERS PAPER
# JUST LIKE YOUR RETRO NES DREAMS

SLEEP_INTERVAL = 5
SYNC_INTERVAL = 5.minutes

Daemons.run_proc('paperboy.rb') do
  # Setup the log
  log = ActiveSupport::BufferedLogger.new(File.join(Rails.root, "log", "paperboy.log"))
  Rails.logger = log
  ActiveRecord::Base.logger = log

  loop {
    blogs = Blog.where("articles_last_syncd_at <= ?", Time.now - SYNC_INTERVAL)
    p blogs.count
    sleep(SLEEP_INTERVAL)
  }
end