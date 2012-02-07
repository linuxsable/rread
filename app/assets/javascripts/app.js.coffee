# I'm stil uncertian how to organize these modules
# in coffeescript but it will evolve. Every new module
# will just exist in this single file for now with "App"
# being the parent.

Log = do ->
	debug: (str) -> console.log str

# App is the parent object
App = do ->
	# Mark articles as read
	updateArticleReadStatus: (articleId, callback = (r) ->) ->
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

# User is stuff the corresponds to the user..
App.User = do ->

# This makes the App var available outside
window.App = App

# This needs to be in each separate pages document.ready and file, etc
$(document).ready ->

	$(document).bind "keydown", "esc", (evt) ->
		$('.article-active').toggleArticle();

	$('.article-inactive').click ->
   	if !$(this).hasClass('article-active')
   		$(this).toggleArticle()

   $('.article-close').click ->
   	$(this).parent().parent().toggleArticle()
   	return false



$.fn.toggleArticle = ->
	article = $(this)
	active = article.hasClass('article-active') ? true : false
	
	$('.article-active').toggleClass('article-active article-inactive')
	
	if !active
		article.toggleClass('article-inactive article-active')
		articleRead = article.hasClass('article-read')
		$(".article-contents a", article).attr("target","_blank");

		if !articleRead
			App.updateArticleReadStatus article.attr('rel')
			article.addClass('article-read')
		
		###
		$("html,body").animate
			scrollTop: article.offset().top
			, 150
		###