App.Reader = do ->
	refreshTimestamp = 0
	refreshArticles = []
	articles = []

	assignListeners = ->
		$('.new-articles').on 'click', ->
			hideNotifactionView()
			insertNewArticles()
			clearArticleCache()
		
		$(document).bind "keydown", "esc", ->
  			closeArticles()

		$('#articles').on 'click', '.article', ->
			closeArticles()
			openArticle $(this)
		
		$(".article").on "click", ".article-close", (event) ->
			closeArticles()
			event.stopPropagation()
			return false

	closeArticles = ->
		$('.article-active').toggleClass('article-active article-inactive')

	openArticle = (article) ->
		article.addClass 'article-active'
		article.removeClass 'article-inactive'

		id = article.attr 'rel'
		
		$('.article-contents', this).html articles[id].content
		$(".article-contents a", article).attr "target", "_blank"

		articleRead = article.hasClass('article-read')

		if !articleRead
			updateArticleReadStatus id
			article.addClass 'article-read'

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

	getAllArticles = ->
		request = $.ajax {
			url: '/reader/show.json',
			type: 'GET'
		}	

		$.when(request).done (result) ->
			if result.success
				cacheNewArticles result
				if result.count
					insertNewArticles()
					stashArticles result
			else
				Log.debug 'Bad getAllArticles response.'
		
		return request
	
	getNewArticles = (timestamp, callback = (r) ->) ->
		request = $.ajax {
			url: '/reader/show.json',
			type: 'GET',
			data: { 'timestamp': timestamp }
		}

		$.when(request).done (result) ->
			if result.success
				callback(result)
				if result.count
					updateNotifcationView()
					showNotifcationView()
			else
				Log.debug 'Bad getNewArticles response.'
		
		return request

	autoRefreshArticles = ->
		setInterval (=>
			getNewArticles refreshTimestamp, cacheNewArticles
			refreshTimestamp = Date.now()
		), 10 * 1000

	cacheNewArticles = (result) ->
		$.each result.articles, ->
			refreshArticles.push this
			stashArticle this

	stashArticle = (article) ->
		articles[article.id] = article
	
	stashArticles = (result) ->
		$.each result.articles, ->
			stashArticle this
	
	clearArticleCache = ->
		refreshArticles = []

	updateNotifcationView = ->
		$('.new-articles').html(refreshArticles.length + ' new articles')

	hideNotifactionView = ->
		$('.new-articles').hide()

	showNotifcationView = ->
		$('.new-articles').show()
	
	insertNewArticles = ->
		source = $("#article-template").html()
		template = Handlebars.compile(source)

		data = articles: refreshArticles
		
		$(".new-articles").after template(data)

	init: ->
		getAllArticles()
		refreshTimestamp = Date.now()
		assignListeners()
		autoRefreshArticles()

	debug: ->
		debugger

	clearArticles: ->
		$('.article').remove()

$ ->
	App.Reader.init()