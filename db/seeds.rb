# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

blogs = [
	{ 
		'url' => 'http://www.techcrunch.com',
		'feed_url' => 'http://feeds.feedburner.com/TechCrunch/',
		'name' => 'TechCrunch'
	},
	{ 
		'url' => 'http://www.venturebeat.com',
		'feed_url' => 'http://feeds.venturebeat.com/VentureBeat',
		'name' => 'Venturebeat'
	},
	{ 
		'url' => 'http://www.theoatmeal.com',
		'feed_url' => 'http://feeds.feedburner.com/oatmealfeed',
		'name' => 'The Oatmeal'
	},
	{ 
		'url' => 'http://37signals.com/svn/',
		'feed_url' => 'http://feeds.feedburner.com/37signals/beMH',
		'name' => 'Signal vs Noise'
	},
	{ 
		'url' => 'http://zenhabits.net/',
		'feed_url' => 'http://feeds.feedburner.com/zenhabits',
		'name' => 'Zen Habits'
	},
	{ 
		'url' => 'http://designsponge.com',
		'feed_url' => 'http://feeds.feedburner.com/designspongeonline/njjl',
		'name' => 'Design Sponge'
	},
	{ 
		'url' => 'http://inc.com',
		'feed_url' => 'http://www.inc.com/rss/homepage.xml',
		'name' => 'INC'
	},
	{ 
		'url' => 'http://uncrate.com',
		'feed_url' => 'http://feeds.feedburner.com/uncrate',
		'name' => 'Uncrate'
	},
	{
		'url' => 'http://buzzbands.la',
		'feed_url' => 'http://buzzbands.la/feed/',
		'name' => 'Buzz Bands'
	},
	{
		'url' => 'http://pitchfork.com',
		'feed_url' => 'http://feeds2.feedburner.com/PitchforkLatestNews',
		'name' => 'Pitchfork'
	},
	{
		'url' => 'http://tuaw.com',
		'feed_url' => 'http://www.tuaw.com/rss.xml',
		'name' => 'The Unofficial Apple Weblog'
	},
	{
		'url' => 'http://theverge.com',
		'feed_url' => 'http://www.theverge.com/rss/index.xml',
		'name' => 'The Verge'
	},
	{
		'url' => 'http://www.boston.com/bigpicture/',
		'feed_url' => 'http://www.boston.com/bigpicture/index.xml',
		'name' => 'The Big Picture'
	}
]

blogs.each { |b|
	Blog.create! { |blog|
		blog.url = b['url']
		blog.feed_url = b['feed_url']
		blog.name = b['name']
		blog.articles_last_syncd_at = Time.now - 6.months
		blog.first_created_by = 1
	}
}

puts '** SYNCING ALL ARTICLES **'

Blog.sync_articles_all
