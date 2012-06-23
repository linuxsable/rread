class window.ReaderView extends Backbone.View
  initialize: ->
    @el = $('.reader')
    @articles = @el.find('.articles')
    @header = @el.find('.left header')

    @collection = new Articles
    @collection.bind('reset', @render, @)
    @collection.fetch()

    @activityFeedView = new ActivityFeedView

  render: =>
    self = @
    @collection.forEach (item) ->
      article = new ArticleView(model: item, readerView: self)
      output = article.render().el
      self.articles.append(output)

  closeAllArticles: ->
    @articles.find('.expanded').each ->
      $(this)
        .removeClass('expanded')
        .find('.content')
          .html('')
          .hide()

  decrementUnreadCount: ->
    $num = @header.find('.left .all-items .num')
    value = parseInt($num.html())
    if value > 0
      $num.html(value - 1)