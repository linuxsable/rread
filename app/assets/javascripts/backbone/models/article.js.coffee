class Rread.Models.Article extends Backbone.Model
  defaults: ->
    {}

  initialize: ->
    null

class Rread.Collections.Articles extends Backbone.Collection
  model: Rread.Models.Article
  url: '/articles'