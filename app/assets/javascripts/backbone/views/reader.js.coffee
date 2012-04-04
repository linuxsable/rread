class Rread.Views.Reader extends Backbone.View
  # el: null

  initialize: ->
    console.log this.el

    this.articles = []
    # this.template = Handlebars.compile( $("#article-template").html() )
    articlesCollection = new Rread.Collections.ReaderArticles

    self = this

    articlesCollection.fetch {
      success: (r) ->
        self.articles = r
        self.render()

      error: ->
        Rread.globalError 'Unable to retrieve articles.'
    }

  render: ->
    console.log this.articles
    # this.articles.each (article) ->
    #   console.log(article)