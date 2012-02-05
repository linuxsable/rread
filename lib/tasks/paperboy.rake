task :heartbeat => :environment do
  loop {
    # RECORD: 4:00PM
    # TIME: 5:00PM
    Blog.where("articles_last_syncd_at >=")
  }

    # loop {
    #     Blog.find_each do |blog|
    #     if !blog.articles_synced?
    #       blog.sync_articles_delayed
    #       p blog.name
    #     end
    #   end

    #   puts 'hi'
    #   sleep 0.5
    # }
end