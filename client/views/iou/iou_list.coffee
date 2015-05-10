Template.iousList.helpers
  ious: ->
    Ious.find({
    $or: [ { payerId: Meteor.userId() }, { payeeId: Meteor.userId() } ]
    })

Template.iousList.events 'click .new' : (e) ->
  e.preventDefault()
  Router.go 'iouNew'
  return

Template.iouItem.helpers
  userName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name
  date: (date) ->
    moment(date).format('MMMM Do YYYY, h:mm:ss a')
