Template.Home.rendered = ->
	$( ".panel").resizable(
		grid: [ 40, 20 ]
		minHeight: 150
		minWidth: 300
	)
	$( ".chores-panel").resizable(
		grid: [ 40, 20 ]
		minHeight: 360
		minWidth: 600
	)

	for moduleName in ['postModule', 'listModule', 'calModule', 'choresModule']
		do (moduleName) ->
			#save the window size to the user
			target = $('#' + moduleName + ' > .panel')
			target.resizable resize: (event, ui) ->
				Meteor.call 'updateModuleLocation', moduleName, ui.size, (error) ->
					if error
						return alert(error.reason) 		
				return

			#set the window size
			Tracker.autorun ->
				if Meteor.user()?.modules[moduleName]?
					console.log target
					target.width(Meteor.user().modules[moduleName].width)
					target.height(Meteor.user().modules[moduleName].height)