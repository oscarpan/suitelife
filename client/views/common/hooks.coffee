Meteor.startup ->
  Hooks.init()

Hooks.onLoggedIn = (userId) ->
	Session.setAuth 'suite', (Suites.findOne users: Meteor.userId())

Hooks.onLoggedOut = (userId) ->
	Session.clear()