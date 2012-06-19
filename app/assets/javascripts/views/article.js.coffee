class window.ArticleView extends Backbone.View
  tagName: 'div'
  className: 'article'

  initialize: ->
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

    return this