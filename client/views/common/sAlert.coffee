Meteor.startup ->
	sAlert.config(
		effect: '',
		position: 'bottom-right',
		timeout: 5000,
		html: false,
		onRouteClose: true,
		stack: true,
		offset: 0
	)