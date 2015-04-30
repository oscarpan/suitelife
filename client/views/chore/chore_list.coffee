Template.choresList.helpers chores: ->
  Chores.find {}, sort: createdAt: -1

Template.choresList.events 'click .new': (e) ->
	e.preventDefault()
	Router.go 'choreNew'
	return
 
