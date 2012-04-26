class Rread.Models.ReaderArticle extends Backbone.Model

  initialize: ->
    formatted_date = moment(@get('published_at'), 'YYYY-MM-DD').fromNow()
    @set('published_at_formatted', formatted_date)
    @set('favicon_url', @get('blog_url').replace('http://', ''))

  # Mark articles as read
  updateReadStatus: (callback = (r) ->) ->
    request = $.ajax {
      url: '/articles/read.json',
      type: 'GET',
      data: { 'id': @get('id') }
    }

    $.when(request).done (result) ->
      if result.success
        callback(result)
      else
        Rread.globalError 'Bad read response.'

    return request

class Rread.Collections.ReaderArticles extends Backbone.Collection
  model: Rread.Models.ReaderArticle
  url: '/reader/article_feed.json'