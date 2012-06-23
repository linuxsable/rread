class window.Rread extends Backbone.Router
  routes: {
    '': 'index'
  }

  index: ->
    reader = new ReaderView

$(document).ready ->
  window.Rread = new Rread
  Backbone.history.start()