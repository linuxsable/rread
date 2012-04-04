class Rread.Routers.Reader extends Backbone.Router
  initialize: (options) ->

  routes: {
    "": "index",
  }

  index: ->
    new Rread.Views.Reader