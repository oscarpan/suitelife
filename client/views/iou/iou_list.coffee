Template.iousList.helpers ious: ->
  Ious.find {}, sort: createdAt: -1

Template.iousList.events 'click .new' : (e) ->
  e.preventDefault()
  Router.go 'iouNew'
  return
