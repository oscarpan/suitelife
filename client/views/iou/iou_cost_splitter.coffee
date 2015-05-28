Template.costSplitter.helpers
  users: ->
    Suites.findOne({ users: Meteor.userId() }).users
  userName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name

## Template.costSplitter.rendered = ->
  ## $(".slider").no
