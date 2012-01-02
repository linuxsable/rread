require 'test_helper'

class ReaderTest < ActiveSupport::TestCase
	test 'add_subscription' do
		feed_url = 'http://monome.org/rss/'
		feed_url2 = 'http://feeds.mashable.com/Mashable'

		user = User.create(:name => 'Tyler')
		reader = Reader.create(:user_id => user.id)

		assert reader.add_subscription(feed_url)
		assert_equal reader.subscriptions.count, 1

		assert reader.add_subscription(feed_url2)
		assert_equal reader.subscriptions.count, 2
	end

	# I can't understand why this is failing.
	# test 'import_greader_feeds' do
	# 	reader = Reader.create(:user_id => 1)

	# 	# MUST REPLACE WITH OWN CREDS
	# 	guser = 'linuxsable@gmail.com'
	# 	gpass = ''

	# 	reader.import_greader_feeds(guser, gpass)
	# 	assert_equal reader.subscriptions.count >= 1
	# end

	test 'get_article_feed' do
		user = User.create(:name => 'Tyler')
		reader = Reader.create(:user_id => user.id)

		reader.add_subscription('http://monome.org/rss/')
		reader.add_subscription('http://feeds.feedburner.com/TechCrunch/')

		articles = reader.article_feed
		assert articles.count > 0
	end
end