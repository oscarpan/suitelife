Template.Home.onRendered ->
	modules = ['postsModule', 'iousModule', 'calModule', 'choresModule']
	bodies = ['postsList', 'iousList', 'choreCal', 'choresList']	
	resizing = false

	$container = $('#home').packery(
		gutter: 30
		transitionDuration: "0.2s"
		)
	# get item elements, jQuery-ify them
	$itemElems = $container.find('.packery-item')
	# make item elements draggable
	$itemElems.draggable(
			handle: "h3"
		)
	# bind Draggable events to Packery
	$container.packery 'bindUIDraggableEvents', $itemElems

	#save the window size to the user
	for i in [0...modules.length]
		do (i) ->

			moduleName = modules[i]
			bodyName = bodies[i]
			padding = 88

			target = $('#' + moduleName)
			targetBody = $('#' + bodyName)
			targetBody.height(target.height() - padding)

			#run update when targets move
			$container.packery 'on', 'layoutComplete', (laidOutItems) ->
				Meteor.call 'updateModuleLocation', moduleName, null, $('#' + moduleName).position(), (error) ->
					if error
						sAlert.error(error.reason)
				#repack the posts inside the bulletin board
				if moduleName == 'postsModule' and $('.postsPackery').data().packery
					$('.postsPackery').data().packery.layout()

			#run update on resize
			target.resizable 
				alsoResize: bodyName
				stop: (event, ui) ->
					#update sizes	
					Meteor.call 'updateModuleLocation', moduleName, ui.size, null, (error) ->
						if error
							sAlert.error(error.reason)
					resizing = false
					$container.packery()	
				resize: (event, ui) ->
					resizing = true
					targetBody.height(target.height() - padding)
					#move all objects to fit

			#set the window size
			Tracker.autorun ->
				#resize based on set values
				if !resizing and Meteor.user()?.modules?[moduleName]?
					location = Meteor.user().modules[moduleName]
					target.width(location.width)
					target.height(location.height)
					targetBody.height(target.height() - padding)
					if location.top?
						target.css('top', location.top)
						target.css('left', location.left)
				#check for collision
				for j in [0...i]
					do (j) -> 	
						target1 = $('#' +modules[j])
						if collision(target,target1)
							$container.packery("unstamp", target)
							$container.packery("unstamp", target1)
							$container.packery()

collision = ($el1, $el2) ->
  x1 = $el1.offset().left
  y1 = $el1.offset().top
  h1 = $el1.outerHeight(true)
  w1 = $el1.outerWidth(true)
  b1 = y1 + h1
  r1 = x1 + w1
  x2 = $el2.offset().left
  y2 = $el2.offset().top
  h2 = $el2.outerHeight(true)
  w2 = $el2.outerWidth(true)
  b2 = y2 + h2
  r2 = x2 + w2
  if b1 < y2 or y1 > b2 or r1 < x2 or x1 > r2
    return false
  true