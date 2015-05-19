Template.Home.rendered = ->
  ###
  $('.panel').hover (->
    $(this).addClass 'panel-info'
    return
  ), ->
    $(this).removeClass 'panel-info'
    return
  ###
