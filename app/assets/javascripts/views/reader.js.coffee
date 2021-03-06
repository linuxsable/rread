class window.ReaderView extends Backbone.View
  el: '.reader'

  events: {
    'click .left header .right a': 'markAllAsRead',
    'click .left header.box .left .all-items a': 'allItems',
    'click .btn-group .dropdown-menu li > a': 'changeSubscription'
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

    $(@articles.children().not('img.spinner')).remove()
    
    @articleSpinner.show()

    if @id?
      @$el.find('.source-title').show()
      @collection.fetch(data: { source: @id })
    else
      @$el.find('.source-title').hide()
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

  markAllAsRead: (e) ->
    e.preventDefault()

    # Don't allow unecessary mark all calls
    return if parseInt(@unreadCount.html()) == 0

    # Send the request
    $.get('/reader/mark_all_as_read', { confirm: true })

    # Add "read" to all articles
    @articles.find('.article:not(.read)').each ->
      $(this).addClass('read')

    # Zero out the unread count
    @unreadCount.html(0)

  moveDown: ->
    if @currentArticle == null
      # Index 0 of articles is the spinner, ignore it
      @currentArticle = $(@articles.children().not('img.spinner')[0])
      @closeAllArticles()
      @currentArticle.click()
    else
      id = @currentArticle.data('id')
      article = @articles.find('.article[data-id="' + id + '"]')
      next = article.next()

      if next.length
        @currentArticle = next
        @closeAllArticles()
        @currentArticle.click()

  moveUp: ->
    if !@currentArticle
      # Don't do anything if there is no current article selected
      return
    else
      id = @currentArticle.data('id')
      article = @articles.find('.article[data-id="' + id + '"]')
      @currentArticle = article.prev().not('img.spinner')

      @closeAllArticles()

      if @currentArticle.length
        @currentArticle.click()
      else
        @currentArticle = null

  scrollToArticle: ($article) ->
    window.scrollTo(0, $article.offset().top - 15)

    # Animated version
    # $('html, body').animate(scrollTop: $article.offset().top - 15, speed)

  changeSubscription: (e) ->
    e.preventDefault()
    id = $(e.target).data('id')
    App.navigate('subscription/' + id, true)

  allItems: (e) ->
    e.preventDefault()
    App.navigate('#', true)