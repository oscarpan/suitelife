Meteor.startup ->
  Hooks.init()
	sAlert.config(
		effect: '',
		position: 'bottom-right',
		timeout: 5000,
		html: false,
		onRouteClose: true,
		stack: true,
		offset: 0
	)
Hooks.onLoggedIn = (userId) ->
	Session.setAuth 'suite', (Suites.findOne users: Meteor.userId())
	Router.go "/"

Hooks.onLoggedOut = (userId) ->
	Session.clear()