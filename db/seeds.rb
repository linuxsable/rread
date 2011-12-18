# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Blog.create! do |b|
	b.url = 'www.techcrunch.com'
	b.feed_url = 'http://feeds.feedburner.com/TechCrunch/'
	b.name = 'TechCrunch'
end

Blog.create! do |b|
	b.url = 'www.engadget.com'
	b.feed_url = 'http://www.engadget.com/rss.xml'
	b.name = 'Engadget'
end

Blog.create! do |b|
	b.url = 'www.venturebeat.com'
	b.feed_url = 'http://feeds.venturebeat.com/VentureBeat'
	b.name = 'Venturebeat'
end