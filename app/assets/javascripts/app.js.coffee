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
	$('.article-inactive').click ->
		$('.article-active').toggleClass 'article-active article-inactive'
		article = $(this)
		article.addClass 'article-read'
		article.toggleClass 'article-inactive article-active'
		App.updateArticleReadStatus article.attr('rel')
		
		$("html,body").animate
      scrollTop: article.offset().top
    , 50