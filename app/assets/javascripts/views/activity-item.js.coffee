class window.ActivityItemView extends Backbone.View
  tagName: 'div'
  className: 'activity-item'

  events: {
    
  }

  initialize: ->
    @template = $('#tpl-activity-item').html()

  render: =>
    self = @
    rendered = Mustache.render(@template, {
      userId: self.model.get('user_id'),
      userName: self.model.get('user_name'),
      userAvatar: self.model.get('user_avatar'),
      targetName: self.model.get('target_name'),
      actionName: ->
        activityType = self.model.get('activity_type')
        if activityType == self.model.ARTICLE_READ
          return 'read'
        else if activityType == self.model.SUBSCRIPTION_ADDED
          return 'subscribed to'
        else if activityType == self.model.FRIENDSHIP_ADDED
          return 'followed'
    })

    @$el.html(rendered)

    # TODO
    # I have to add the avatar this way, instead of in the
    # mustache view, because I don't know how to add mustache
    # tags inside haml for an image "src". So this is a hack.
    @$el.find('img').attr('src', @model.get('user_avatar'))
    
    return this