# I'm stil uncertian how to organize these modules
# in coffeescript but it will evolve. Every new module
# will just exist in this single file for now with "App"
# being the parent.

Log = do ->
	debug: (str) -> console.log str

# App is the parent object
App = do ->
	init: ->

App.Reader = do ->
	refreshTimestamp = 0
	refreshArticles = []

	assignListeners = ->
		$('.new-articles').on 'click', ->
			hideNotifactionView()
			insertNewArticles()
		
		$(document).bind "keydown", "esc", ->
  			toggleArticle $(this)

		$('.article').bind 'click', ->
			toggleArticle $(this)

	toggleArticle = (article) ->
		active = article.hasClass('article-active') ? true : false
		
		$('.article-active').toggleClass('article-active article-inactive')
		
		if !active
			article.toggleClass('article-inactive article-active')
			articleRead = article.hasClass('article-read')
			$(".article-contents a", article).attr("target","_blank");

			if !articleRead
				updateArticleReadStatus article.attr('rel')
				article.addClass('article-read')

			article.ScrollTo
	  			duration: 0

	# Mark articles as read
	updateArticleReadStatus = (articleId, callback = (r) ->) ->
		return false if not articleId?

		request = $.ajax {
			url: '/article/read.json',
			type: 'GET',
			data: { 'id': articleId }
		}

		$.when(request).done (result) ->
			if result.success
				callback(result)
			else
				Log.debug 'Bad read response.'

		return request
	
	getNewArticles = (timestamp, callback = (r) ->) ->
		request = $.ajax {
			url: '/reader/recent_articles.json',
			type: 'GET',
			data: { 'timestamp': timestamp }
		}

		$.when(request).done (result) ->
			if result.success
				callback(result)
			else
				Log.debug 'Bad getNewArticles response.'
		
		return request

	autoRefreshArticles = ->
		setInterval (=>
			getNewArticles refreshTimestamp, cacheNewArticles
			refreshTimestamp = Date.now()
		), 5000

	cacheNewArticles = (result) ->
		$.each result.articles, ->
			refreshArticles.push this

	updateNotifcationView = ->

	hideNotifactionView = ->
		$('.new-articles').fadeOut()

	showNotifcationView = ->
		$('.new-articles').fadeIn()
	
	insertNewArticles = (result) ->
	
		source = $("#article-template").html()
		template = Handlebars.compile(source)
		data = users: [
		  username: "alan"
		  firstName: "Alan"
		  lastName: "Johnson"
		  email: "alan@test.com"
		,
		  username: "allison"
		  firstName: "Allison"
		  lastName: "House"
		  email: "allison@test.com"
		,
		  username: "ryan"
		  firstName: "Ryan"
		  lastName: "Carson"
		  email: "ryan@test.com"
		 ]
		$("#articles").html template(data)
		console.log result

	init: ->
		refreshTimestamp = Date.now()
		assignListeners()
		autoRefreshArticles()

		$('.article-inactive').click ->
	   	if !$(this).hasClass('article-active')
	   		$(this).toggleArticle()

	   	$('.article-close').click ->
	   		$(this).parent().parent().toggleArticle()
	   	return false

	debug: ->
		debugger
				
# User is stuff the corresponds to the user..
App.User = do ->

# This makes the App var available outside
window.App = App

# This needs to be in each separate pages document.ready and file, etc
$(document).ready ->
	App.Reader.init()
