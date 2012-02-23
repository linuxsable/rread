App.Reader = do ->
	refreshTimestamp = 0
	refreshInterval = 60
	refreshArticles = []
	articles = []
	activeArticle = null
	source = null
	articleHeaderOffset = 0
	isFixed = 0

	assignListeners = ->
		$('.new-articles').on 'click', ->
			hideNotifactionView()
			insertNewArticles()
			clearArticleCache()
		
		$(document).bind "keydown", "esc", ->
  			closeArticles()
  		
		$(document).bind "keydown", "j", ->
			if activeArticle == null
				openArticle $('#articles .article').first()
			else
				if activeArticle.next('.article').length
					openArticle activeArticle.next('.article')
		
		$(document).bind "keydown", "k", ->
			return if activeArticle == null
			if activeArticle.prev('.article').length
				openArticle activeArticle.prev()

		$('#articles').on 'click', '.article', ->
			openArticle $(this)
		
		$(".article").on "click", ".article-close", (event) ->
			closeArticles()
			event.stopPropagation()
			return false

		$('#main-header').on 'click', ->
			$('html, body').animate scrollTop 0
			, 800
		
		$(window).on "scroll", ->
			scrollTop = $(this).scrollTop()
			if scrollTop >= articleHeaderOffset and not isFixed
			  isFixed = 1
			  $('#main-header').addClass "subnav-fixed"
			else if scrollTop <= articleHeaderOffset and isFixed
			  isFixed = 0
			  $('#main-header').removeClass "subnav-fixed"

	closeArticles = (shades = true) ->
		$('.article-active').toggleClass('article-active article-inactive')
		if shades
			$('.article, #right').css opacity: '1'

	openArticle = (article) ->
		closeArticles(false)
		activeArticle = article
		article.addClass 'article-active'
		article.removeClass 'article-inactive'

		id = article.attr 'rel'
		$('.article-contents', article).html articles[id].content
		$(".article-contents a", article).attr "target", "_blank"

		#article.siblings().animate opacity: '.2'
		#$('#right').animate opacity: '.2'
		#article.css opacity: '1'

		articleRead = article.hasClass('article-read')

		if !articleRead
			updateArticleReadStatus id
			article.addClass 'article-read'

		$.scrollTo(article, { offset: -articleHeaderOffset })

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
		showLoader()
		clearArticleCache()
		activeArticle = null
		request = $.ajax {
			url: '/reader/show.json',
			type: 'GET'
			data: { 'source': source || undefined }
		}

		$.when(request).done (result) ->
			if result.success
				cacheNewArticles result
				if result.count
					hideLoader()
					insertNewArticles()
					stashArticles result
			else
				Log.debug 'Bad getAllArticles response.'
		
		return request
	
	getNewArticles = (timestamp, callback = (r) ->) ->
		request = $.ajax {
			url: '/reader/show.json',
			type: 'GET',
			data: { 
				'timestamp': timestamp || undefined
				'source': source || undefined
			}
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
		), refreshInterval * 1000

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

	showLoader = ->
		$('#articles').addClass 'loading'
	
	hideLoader = ->
		$('#articles').removeClass 'loading'
	
	insertNewArticles = ->
		src = $("#article-template").html()
		template = Handlebars.compile(src)

		data = articles: refreshArticles
		
		$(".new-articles").after template(data)

	init: ->
		getAllArticles()
		refreshTimestamp = Date.now()
		assignListeners()
		autoRefreshArticles()
		articleHeaderOffset = $('#main-header').offset().top

	debug: ->
		debugger

	changeSource: (s) ->
		source = s
		$('.article').remove()
		getAllArticles()

$ ->
	App.Reader.init()
