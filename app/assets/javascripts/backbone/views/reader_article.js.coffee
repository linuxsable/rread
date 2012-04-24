class Rread.Views.ReaderArticle extends Backbone.View
  initialize: (model) ->
    @model = model
    @render()

  render: ->
    m = @model
    view = Mustache.render(
      $('#reader-article-tpl').html(),
      _.extend(@model.toJSON(), {
        article_read: ->
          if m.get('read')
            return 'article-read'
          return ''
      })
    )

    $('#articles').append(view)