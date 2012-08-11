class window.ArticleView extends Backbone.View
  tagName: 'div'
  className: 'article'

  events: {
    'click': 'clicked'
  }

  initialize: ->
    @readerView = @options.readerView
    @template = $('#tpl-article').html()

  # Apparently always use fat arrow for render
  # to get rid of binding all in init
  render: =>
    renderedContent = Mustache.render(@template, {
      blogName: @model.get('blog_name'),
      title: @model.get('title'),
      date: moment(@model.get('published_at')).fromNow(),
      faviconURL: 'http://www.google.com/s2/favicons?domain=' + @model.get('blog_url').replace('http://', '')
    })

    @$el.attr('data-id', @model.get('id'))

    @$el.addClass('read') if @model.get('read')
    @$el.addClass('liked') if @model.get('liked')

    @$el.html(renderedContent)

    @$content = @$el.children('.content')

    return this

  clicked: ->
    # This is used by the reader view
    # for it's going up and down articles
    @readerView.currentArticle = @$el

    if @$el.hasClass('expanded')
      @close()
    else
      @readerView.closeAllArticles()
      @expand()
      @read()

  close: ->
    @$el.removeClass('expanded')
    @$el.find('.content')
      .html('')
      .hide()

  expand: ->
    console.time('article_render')

    @$el.addClass('expanded')
    @$el.find('.content')
      .html(@model.get('content'))
      .show()
    @readerView.scrollToArticle(@$el)
    @removeStyleTags()
    @hideTinyImages()
    @removeFeedFlare()
    @removeEmptyTags()

    console.timeEnd('article_render')

  # Send ajax read request and update
  # the view to show that it's read.
  read: ->
    return if @$el.hasClass('read')
    @model.read()
    @$el.addClass('read')
    @readerView.decrementUnreadCount()

  # This is that extra junk in the footer from
  # rss aggregator thingies.
  removeFeedFlare: ->
    $feedFlare = @$el.find('.content .feedflare')
    $feedFlare.next().remove()
    $feedFlare.prev().remove()
    $feedFlare.prevAll('br').eq(0).remove()
    $feedFlare.remove()

  removeStyleTags: ->
    @$content.find('*[style]').removeAttr('style')

  removeImages: ->
    @$content.find('img').remove()

  hideTinyImages: ->
    items = @$content.find('img').filter ->
      $this = $(this)
      return $this.width() < 2 && $this.height() < 2

    items.hide()

  removeEmptyTags: ->    
    items = @$content.contents('a, p, div, span, em, strong').filter ->
      return $.trim($(this).text()) == ''

    items.remove()