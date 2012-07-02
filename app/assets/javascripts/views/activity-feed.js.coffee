class window.ActivityFeedView extends Backbone.View
  el: '.reader .right .activity-feed'

  initialize: ->
    @activities = new Activities
    @activities.bind('reset', @render, @)
    @activities.fetch()

  render: =>
    self = @
    @activities.forEach (item) ->
      activity = new ActivityView(model: item)
      output = activity.render().el
      self.$el.append(output)