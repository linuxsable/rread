class Rread.Models.ReaderArticle extends Backbone.Model
  defaults: ->

  initialize: ->
    formatted_date = moment(@get('published_at'), 'YYYY-MM-DD').fromNow()
    @set('published_at_formatted', formatted_date)
    @set('favicon_url', @get('blog_url').replace('http://', ''))

class Rread.Collections.ReaderArticles extends Backbone.Collection
  model: Rread.Models.ReaderArticle
  url: '/reader/article_feed.json'