require 'test_helper'

class ReaderTest < ActiveSupport::TestCase
	test 'add_subscription' do
		feed_url = 'http://monome.org/rss/'
		user = User.create(:name => 'Tyler')
		reader = Reader.create(:user_id => user.id)

		assert reader.add_subscription(feed_url)
		assert_equal reader.subscriptions.count, 1
	end

	test 'import_greader_feeds' do
		reader = Reader.create(:user_id => 1)

		# MUST REPLACE WITH OWN CREDS
		guser = 'linuxsable@gmail.com'
		gpass = ''

		reader.import_greader_feeds(guser, gpass)

		assert reader.subscriptions.count > 0
	end
end