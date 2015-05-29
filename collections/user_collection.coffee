Meteor.methods
	updateModuleLocation: (module, size, position) ->
		moduleSet = if Meteor.user()?.modules then Meteor.user().modules else {}	#cannot set var as key w/o building it then updating
		if !moduleSet[module]?
			moduleSet[module] = {}
		if size?
			moduleSet[module].width = size.width
			moduleSet[module].height = size.height
		if position?
			moduleSet[module].left = position.left
			moduleSet[module].top = position.top
		Meteor.users.update Meteor.userId(), $set: {modules: moduleSet} 