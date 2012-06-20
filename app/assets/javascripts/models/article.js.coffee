class window.Article extends Backbone.Model
  read: ->
    $.get('/articles/read', { id: this.id })

  like: ->
    $.get('/articles/like', { id: this.id })