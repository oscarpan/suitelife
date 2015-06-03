Meteor.subscribe 'suites'
Meteor.subscribe 'ious'
Meteor.subscribe 'users'

Template.postsList.onRendered ->
	#give time to load
	window.setTimeout((
		
		#packery for posts
		$postsContainer = $('.postsPackery').packery(
			columnWidth: 60
			gutter: 15
			transitionDuration: 0
		)
		#set up packery for posts
		window.setInterval (->

			######subscriptions######
			if Suites?
				suite = Suites.findOne users: Meteor.userId()
				if suite?
					Meteor.subscribe 'posts', suite.post_ids
					Meteor.subscribe 'chores', suite.chore_ids
			######subscriptions######

			if $postsContainer?
				$postsContainer.packery 'destroy'
			$postsContainer = $('.postsPackery').packery(
				columnWidth: 60
				gutter: 15
				transitionDuration: 0
			)
			# get item elements, jQuery-ify them
			$postsItemElems = $postsContainer.find('.post-item')
			# bind Draggable events to Packery
			$postsContainer.packery 'bindUIDraggableEvents', $postsItemElems
		), 250
	), 250)
