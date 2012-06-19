class window.Article extends Backbone.Model
  read: ->
    $.post('/articles/read.json', {
      id: this.id
    })

  like: ->
    # Make ajax call to like it