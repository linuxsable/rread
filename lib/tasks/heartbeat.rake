task :heartbeat => :environment do
	loop {
		Blog.find_each do |blog|
	    if !blog.articles_synced?
	      blog.sync_articles_delayed
	      p blog.name
	    end
	  end

	  puts 'hi'
	  sleep 0.5
	}
end