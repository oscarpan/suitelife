Template.iousList.helpers ious: ->
  Suites.findOne( { users: Meteor.userId() } ).ious

Template.iousList.events 'click .new' : (e) ->
  e.preventDefault()
  Router.go 'iouNew'
  return
