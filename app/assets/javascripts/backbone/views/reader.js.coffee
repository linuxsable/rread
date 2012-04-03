class Rread.Views.Reader extends Backbone.View
  el: null
  template: null

  initialize: ->
    this.render()

  render: ->
    console.log this.collection