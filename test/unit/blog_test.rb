require 'test_helper'

class BlogTest < ActiveSupport::TestCase
	fixtures :blogs

  # Validations
  test 'presence validation' do
    blog = Blog.new
    
    assert !blog.valid?
    assert blog.invalid?(:url)
    assert blog.invalid?(:feed_url)
    assert blog.invalid?(:name)
    assert blog.invalid?(:first_created_by)
  end

  test 'url unique validation' do
    b = get_blog
    b.url = blogs(:techcrunch).url
    b.save

    assert b.invalid? :url
  end

  test 'feed_url unique valdation' do
    b = get_blog
    b.feed_url = blogs(:techcrunch).feed_url
    b.save

    assert b.invalid? :feed_url
  end

  test 'name unique valdation' do
    b = get_blog
    b.name = blogs(:techcrunch).name
    b.save

    assert b.invalid? :name
  end

  test 'valid url types validation' do
    b = get_blog
    b.feed_url = 'hi'
    b.url = 'hello'
    b.save

    assert b.invalid? :feed_url
    assert b.invalid? :url
  end

  test 'create_from_feed_url' do
    user = User.create(:name => 'Tyler')
    feed_url = 'http://monome.org/rss/'

    blog = nil
    assert_nothing_raised {
      blog = Blog.create_from_feed_url(user, feed_url)  
    }

    assert_equal blog.first_created_by, user.id
    assert_not_nil blog.articles_last_syncd_at
    assert_not_nil blog.name
  end

  def get_blog
  	Blog.new do |blog|
  		blog.url = 'http://www.testblog.com'
      blog.feed_url = 'http://www.testblog.com/rss'
      blog.name = 'Test Blog'
      blog.description = 'test test test'
      blog.first_created_by = 1
      blog.avatar = 'test'
      blog.articles_last_syncd_at = Time.now
  	end
  end

end
