Meteor.methods
	updateModuleLocation: (module, size) ->
		moduleSet = if Meteor.user().modules then Meteor.user().modules else {}	#cannot set var as key w/o building it then updating
		moduleSet[module] = size;
		Meteor.users.update Meteor.userId(), $set: {modules: moduleSet} 
		