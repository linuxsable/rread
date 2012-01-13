# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('.article h3 a').click ->
    $(this).addClass 'read'
    $(this).parent().parent().children('.guts').toggle()
    
    $("html,body").animate
      scrollTop: $(this).offset().top - 50
    , 200
    return false