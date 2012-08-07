class window.Rread extends Backbone.Router
  routes: {
    '': 'index',
    'subscription/:id': 'subscription'
  }

  index: ->
    reader = new ReaderView

  subscription: (id) ->
    reader = new ReaderView(id: id)

$(document).ready ->
  # Fixes a pesky issue with facebook auth
  if window.location.hash == '#_=_'
    window.location.hash = ''
    history.pushState('', document.title, window.location.pathname)

  window.App = new Rread
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