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

# This makes the App var available outside
window.App = App

# This needs to be in each separate pages document.ready and file, etc
$ ->
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

	AppRouter = Backbone.Router.extend(
	  routes:
	    "source/:query": "source"

	  source: (query) ->
	  	App.Reader.clearArticles()
	)

	app_router = new AppRouter
	Backbone.history.start()