class Rread.Models.ReaderArticle extends Backbone.Model
  defaults: ->

  initialize: ->

class Rread.Collections.ReaderArticles extends Backbone.Collection
  model: Rread.Models.ReaderArticle
  url: '/reader/article_feed.json'