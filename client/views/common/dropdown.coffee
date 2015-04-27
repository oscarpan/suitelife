Template.dropdown.events 'click .list_item': (e) ->
	e.preventDefault()
	user = Meteor.user()
	suite_id = e.target.id
	Meteor.call 'addSuitetoUser', user._id, suite_id, (error, id) ->
		if error
		  return alert(error.reason)
		return
	return 
