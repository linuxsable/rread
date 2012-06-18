class window.ArticleView extends Backbone.View
  tagName: 'div'
  className: 'article'

  initialize: ->
    @template = $('#tpl-article').html()

  # Apparently always use fat arrow for render
  # to get rid of binding all in init
  render: =>
    renderedContent = Mustache.render(@template, {
      title: 'test'
    })
    
    $(@el).html(renderedContent)

    return this