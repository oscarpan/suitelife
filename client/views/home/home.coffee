Template.Home.rendered = ->
	modules = ['postModule', 'iousModule', 'calModule', 'choresModule']

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

	$container = $('.packery').packery(
		columnWidth: 40
		rowHeight: 20
		gutter: 20)
	# get item elements, jQuery-ify them
	$itemElems = $container.find('.packery-item')
	# make item elements draggable
	$itemElems.draggable()
	# bind Draggable events to Packery
	$container.packery 'bindUIDraggableEvents', $itemElems


	#save the window size to the user
	for moduleName in modules
		do (moduleName) ->

			targetContainer = $('#' + moduleName)
			target = $('#' + moduleName + ' > .panel')

			#run update when targets move
			$container.packery 'on', 'layoutComplete', (laidOutItems) ->
				Meteor.call 'updateModuleLocation', moduleName, null, $('#' + moduleName).position(), (error) ->
					if error
						return alert(error.reason)
					
			#run update on resize
			target.resizable 
				stop: (event, ui) ->
					#move all objects to fit
					$container.packery()	
					#update sizes	
					Meteor.call 'updateModuleLocation', moduleName, ui.size, null, (error) ->
						if error
							return alert(error.reason)

			#set the window size
			Tracker.autorun ->
				if Meteor.user()?.modules?[moduleName]?
					location = Meteor.user().modules[moduleName]
					target.width(location.width)
					target.height(location.height)
					if location.top?
						targetContainer.css('top', location.top)
						targetContainer.css('left', location.left)					
