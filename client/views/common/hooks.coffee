Meteor.startup ->
  Hooks.init()

Hooks.onLoggedIn = (userId) ->
	Session.setAuth 'suite', (Suites.findOne users: Meteor.userId())
	Router.go "/"

Hooks.onLoggedOut = (userId) ->
	Session.clear()