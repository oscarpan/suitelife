Meteor.subscribe 'suites', ->
	#update whenever values change
	Tracker.autorun ->
		#keep trying to find Suites
		suiteInterval = window.setInterval (->	
			if Suites?
				suite = Suites.findOne users: Meteor.userId()
				Meteor.subscribe 'chores', suite.chore_ids
				Meteor.subscribe 'posts', suite.post_ids
				clearInterval(suiteInterval)
			else
				console.log "Suites not found"
		), 100		
Meteor.subscribe 'ious'
Meteor.subscribe 'users'
