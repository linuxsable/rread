require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
	fixtures :articles

	test 'presence validation' do
		a = Article.new
		
		assert !a.valid?
		assert a.invalid? :title
		assert a.invalid? :content
		assert a.invalid? :published_at
		assert a.invalid? :url
	end
	
	test 'content unique validation' do
	  a = get_article
	  a.content = articles(:one).content
	  a.save
	  
	  assert a.invalid?(:content)
  end
  
  test 'published_at unique validation' do
    a = get_article
    a.published_at = articles(:one).published_at
    a.save
    
    b = get_article
    b.published_at = articles(:one).published_at
    b.save
    
    pp Blog.all
    
    assert b.invalid?(:published_at)
  end
  
  test 'url unique validation' do
    a = get_article
    a.url = articles(:one).url
    a.save
    
    assert a.invalid?(:url)
  end
  
  test 'valid url validation' do
    a = get_article
    a.url = 'o3aughaierughaegwr'
    a.save
    
    assert a.invalid?(:url)
  end

	def get_article
		Article.new do |article|
			article.blog_id = 1
			article.title = 'hi'
			article.author = 'Tyler'
			article.content = 'Yup!'
			article.published_at = Time.now
			article.url = 'http://www.testblog.com'
		end
	end
end
