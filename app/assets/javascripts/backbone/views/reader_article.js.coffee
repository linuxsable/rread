class Rread.Views.ReaderArticle extends Backbone.View
  el: null
  template: null

  initialize: ->
    this.render()

  render: ->
    console.log this.collection