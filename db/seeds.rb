# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

LAST_SYNCD_AT = Time.now - 6.months

Blog.create! do |b|
	b.url = 'http://www.techcrunch.com'
	b.feed_url = 'http://feeds.feedburner.com/TechCrunch/'
	b.name = 'TechCrunch'
	b.articles_last_syncd_at = LAST_SYNCD_AT
	b.first_created_by = 1
end

Blog.create! do |b|
	b.url = 'http://www.engadget.com'
	b.feed_url = 'http://www.engadget.com/rss.xml'
	b.name = 'Engadget'
	b.articles_last_syncd_at = LAST_SYNCD_AT
	b.first_created_by = 1
end

Blog.create! do |b|
	b.url = 'http://www.venturebeat.com'
	b.feed_url = 'http://feeds.venturebeat.com/VentureBeat'
	b.name = 'Venturebeat'
	b.articles_last_syncd_at = LAST_SYNCD_AT
	b.first_created_by = 1
end

Blog.create! do |b|
	b.url = 'http://www.theoatmeal.com'
	b.feed_url = 'http://feeds.feedburner.com/oatmealfeed'
	b.name = 'The Oatmeal'
	b.articles_last_syncd_at = LAST_SYNCD_AT
	b.first_created_by = 1
end

Blog.create! do |b|
	b.url = 'http://37signals.com/svn/'
	b.feed_url = 'http://feeds.feedburner.com/37signals/beMH'
	b.name = 'Signal vs Noise'
	b.articles_last_syncd_at = LAST_SYNCD_AT
	b.first_created_by = 1
end

Blog.create! do |b|
	b.url = 'http://zenhabits.net/'
	b.feed_url = 'http://feeds.feedburner.com/zenhabits'
	b.name = 'Zen Habits'
	b.articles_last_syncd_at = LAST_SYNCD_AT
	b.first_created_by = 1
end

Blog.create! do |b|
	b.url = 'http://designsponge.com'
	b.feed_url = 'http://feeds.feedburner.com/designspongeonline/njjl'
	b.name = 'Design Sponge'
	b.articles_last_syncd_at = LAST_SYNCD_AT
	b.first_created_by = 1
end

Blog.sync_articles_all