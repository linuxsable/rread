# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('.article h3 a').click ->
    $('.article.active').removeClass('active')
    article = $(this).parent().parent()
    article.addClass 'read active'
    
    $("html,body").animate
      scrollTop: $(this).offset().top - 50
    , 0
    return false