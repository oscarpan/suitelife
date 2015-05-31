Template.suiteNew.events 'submit form': (e) ->
	e.preventDefault()
	suite_name = name: $(e.target).find('[name=suiteName]').val()
	Meteor.call 'newSuite', suite_name, (error, id) ->
		if error
			sAlert.error(error.reason)		
		else
			Router.go("/")
