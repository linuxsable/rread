class Rread.Routers.Reader extends Backbone.Router
  initialize: (options) ->
    return

  routes: {
    "": "index",
  }

  index: ->
    articles = new Rread.Collections.Articles
    articles.fetch {
      success: ->
        new Rread.Views.Reader({ collection: articles })

      error: ->
        console.log 'Failed to load articles'
    }