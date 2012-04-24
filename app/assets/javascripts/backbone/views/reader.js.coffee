class Rread.Views.Reader extends Backbone.View
  el: $('#main')
  activeArticle: null
  articleHeaderOffset: 0

  events: {
    'click #articles': 'openArticle'
  }

  initialize: ->
    @articlesCollection = new Rread.Collections.ReaderArticles
    @render()

  render: ->
    @renderArticleFeed()

  renderArticleFeed: ->
    @articlesCollection.fetch {
      success: (r) ->
        r.each (index) ->
          new Rread.Views.ReaderArticle(index)
      error: ->
        Rread.globalError 'Unable to retrieve articles.'
    }

  closeArticles: (shades = true) ->
    $('.article-active').toggleClass('article-active article-inactive')
    if shades 
      $('.article, #right').css('opacity', 1)

  openArticle: (article) ->
    console.log('hi')
    closeArticles(false)
    @activeArticle = article
    article.addClass('article-active')
    article.removeClass('article-inactive')

    id = article.attr('rel')
    $('.article-contents', article).html(articles[id].content)
    $(".article-contents a", article).attr("target", "_blank")

    articleRead = article.hasClass('article-read')

    if !articleRead
      @updateArticleReadStatus(id)
      article.addClass('article-read')

    $.scrollTo(article, { offset: -@articleHeaderOffset })

  # Mark articles as read
  updateArticleReadStatus: (articleId, callback = (r) ->) ->
    return false if not articleId?

    request = $.ajax {
      url: '/articles/read.json',
      type: 'GET',
      data: { 'id': articleId }
    }

    $.when(request).done (result) ->
      if result.success
        callback(result)
      else
        Rread.globalError 'Bad read response.'

    return request