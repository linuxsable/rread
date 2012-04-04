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

  globalError: (msg) ->
    alert(msg)

$(document).ready ->
  Rread.init()
  Backbone.history.start()