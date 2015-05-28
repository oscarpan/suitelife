Template.costSplitter.helpers
  users: ->
    Suites.findOne({ users: Meteor.userId() }).users
  userName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name

Template.costSplitter.events
  'keypress #amount': (e) ->
    usersList = Suites.findOne({ users: Meteor.userId() }).users
    #usersList : rsEQZAcSkSRcoKyZv,iEGn8MtLz4vgQ6doF
    alert(usersList)
    return
