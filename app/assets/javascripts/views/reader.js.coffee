class window.ReaderView extends Backbone.View
  initialize: ->
    @el = $('.reader .articles')

    @collection = new Articles
    @collection.bind('reset', @render, @)
    @collection.fetch()

  render: =>
    self = @
    @collection.forEach (item) ->
      article = new ArticleView(model: item)
      output = article.render().el
      self.el.append(output)