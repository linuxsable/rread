class window.ReaderView extends Backbone.View
  el: '.reader'

  events: {
    'click .left header .right a': 'markAllAsRead'
  }

  shortcuts: {
    'j': 'moveDown',
    'k': 'moveUp',
    'esc': 'closeAllArticles'
  }

  initialize: ->
    @header = @$el.find('.left header')
    @articles = @$el.find('.articles')
    @unreadCount = @$el.find('.left .all-items .num')
    @articleSpinner = @articles.find('img.spinner')
    @currentArticle = null

    # Setup keyboard shortcuts
    _.extend(@, new Backbone.Shortcuts)
    @delegateShortcuts()

    @collection = new Articles
    @collection.bind('reset', @render, @)
    @collection.fetch()

    @activityFeedView = new ActivityFeedView

  render: =>
    @articleSpinner.hide()

    self = @
    @collection.forEach (item) ->
      article = new ArticleView(model: item, readerView: self)
      output = article.render().el
      self.articles.append(output)

  closeAllArticles: ->
    @articles.find('.article.expanded').each ->
      $(this)
        .removeClass('expanded')
        .find('.content')
          .html('')
          .hide()

  decrementUnreadCount: ->
    value = parseInt(@unreadCount.html())
    if value > 0
      @unreadCount.html(value - 1)

  markAllAsRead: ->
    # Send the request
    $.get('/reader/mark_all_as_read', { confirm: true })

    # Add "read" to all articles
    @articles.find('.article:not(.read)').each ->
      $(this).addClass('read')

    # Zero out the unread count
    @unreadCount.html(0)

  moveDown: ->
    if !@currentArticle
      articleId = $(@articles.children()[0]).data('id')
      @currentArticle = @collection.get(articleId)

    @closeAllArticles()

    currentArticleView = 
    currentArticleView.expand()

  moveUp: ->
    console.log('up')