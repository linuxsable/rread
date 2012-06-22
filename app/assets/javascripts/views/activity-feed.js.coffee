class window.ActivityFeedView extends Backbone.View
  initialize: ->
    @el = $('.reader .right .activity-feed')

    @activities = new ActivityItems
    @activities.bind('reset', @render, @)
    @activities.fetch()

  render: =>
    self = @
    @activities.forEach (item) ->
      activity = new ActivityItemView(model: item)
      output = activity.render().el
      self.el.append(output)