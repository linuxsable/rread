# I'm stil uncertian how to organize these modules
# in coffeescript but it will evolve. Every new module
# will just exist in this single file for now with "App"
# being the parent.

Log = do ->
	debug: (str) -> console.log str

# App is the parent object
App = do ->
	init: ->
				
# User is stuff the corresponds to the user..
App.User = do ->

App.Views = {}

App.Activity = Backbone.Model.extend()
App.ActivityFeed = Backbone.Collection.extend(
	model: App.Activity
	url: "/feed/show.json"

	initialize: ->
		this.on "add", (activity) ->
	  	view = new App.Views.Activity(model: activity)
	  	$("#list").append view.render().el

	  this.on "reset", ->
	  	this.each (activity) ->
	  		view = new App.Views.Activity(model: activity)
	  		$("#list").append view.render().el
)

App.Views.Activity = Backbone.View.extend(
  tagName: "li"

  initialize: ->
    @model.bind "change", @render, this

  render: ->
    template = Handlebars.compile($("#activity-row").html())
    @$el.html template(@model.toJSON())
    this
)

App.Router = Backbone.Router.extend(
  routes:
    "source/:source": "source"

  source: (source) ->
  	App.Reader.changeSource(source)
)

# This makes the App var available outside
window.App = App

# This needs to be in each separate pages document.ready and file, etc
$ ->
	App.AF = new App.ActivityFeed

	App.AF.reset af

	Handlebars.registerHelper "time", (time) ->
	  result = $.timeago time
	  new Handlebars.SafeString(result)

	Handlebars.registerHelper "article_read", (read) ->
		result = ''
		if read
			result = 'article-read'
		new Handlebars.SafeString(result)

	Handlebars.registerHelper "favicon_url", (url) ->
		result = url.replace 'http://', ''
		new Handlebars.SafeString(result)

	App.router = new App.Router
	Backbone.history.start()