class window.Rread extends Backbone.Router
  routes: {
    '': 'index'
  }

  index: ->

$(document).ready ->
  window.Rread = new Rread
  Backbone.history.start()