class Rread.Views.ReaderArticle extends Backbone.View
  model: null
  template: $('#reader-article-tpl')

  initialize: (model) ->
    @model = model
    @render()

  render: ->
    # view = Mustache.render(@template, {
    #   title: @model.get('title')
    # })

    $('#articles').append('<div>' + @model.get('title') + '</div>')