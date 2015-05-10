Template.dropdown.events 'click .list_item': (e) ->
	e.preventDefault()
	suite_id = e.target.id
	Meteor.call 'addUserToSuite', suite_id, (error, id) ->
		if error
		  return alert(error.reason)
		else
			Router.go("/")