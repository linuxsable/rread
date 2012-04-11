class Rread.Views.Reader extends Backbone.View
  initialize: ->
    this.articles = []
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
    @renderArticleFeed()

  renderArticleFeed: ->
    this.articles.each (index) ->
      new Rread.Views.ReaderArticle(index)