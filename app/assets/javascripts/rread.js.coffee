class window.Rread extends Backbone.Router
  routes: {
    '': 'index'
  }

  index: ->
    reader = new ReaderView

$(document).ready ->
  window.Rread = new Rread
  Backbone.history.start()

  # Setup moment.js
  moment.relativeTime =
    future: "%s"
    past: "%s"
    s: "%s"
    m: "%dm"
    mm: "%dm"
    h: "%dh"
    hh: "%dh"
    d: "%dd"
    dd: "%dd"
    M: "%dm"
    MM: "%dm"
    y: "%dy"
    yy: "%dy"