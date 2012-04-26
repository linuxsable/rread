class Rread.Views.Reader extends Backbone.View
  el: '#main'
  activeArticle: null
  articleHeaderOffset: 0

  events: {
    'click .article.article-inactive': 'openArticle'
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

  openArticle: (event) ->
    $article = $(event.target).parent('.article')
    
    @closeArticles(false)
    @activeArticle = article

    article.addClass('article-active')
    article.removeClass('article-inactive')

    id = article.attr('rel')
    model = @articlesCollection.get(id)

    $('.article-contents', article).html(model.get('content'))
    $(".article-contents a", article).attr("target", "_blank")

    articleRead = article.hasClass('article-read')

    if !articleRead
      @updateArticleReadStatus(id)
      article.addClass('article-read')

    $.scrollTo(article, { offset: -@articleHeaderOffset })