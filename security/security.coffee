Meteor.users.allow
	update: (userId, user) ->
	  userId == user._id	

Suites.allow 
  insert: -> 
    true
  update: ->
    true
