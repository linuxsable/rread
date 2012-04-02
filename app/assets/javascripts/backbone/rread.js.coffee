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

$(document).ready ->
  Rread.init()