#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Rread =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  init: ->
    new Rread.Routers.Reader

  # This will be refactored into a pretty
  # user notification for errors and messages.
  globalError: (msg) ->
    alert(msg)

$(document).ready ->
  Rread.init()
  Backbone.history.start()