EditableText.registerCallbacks 
	whoDunnitPosts: (doc, collection) ->
		Posts.update doc._id, $set: 
			lastEditor: Meteor.userId()
			lastEdited: moment().format 'MMMM Do YYYY, h:mm:ss a'
	validateIOUAmount: ( doc, collection ) ->
		## Ensure new amount is not negative
		if Number this.newValue < 0
			alert "Amount must be a numeric value not less than 0."
		## Ensure new amount is a valid number
		else if isNaN this.newValue
			alert "New amount must be a valid monetary value."
		else
			Meteor.call 'editIou', doc, { fieldName: "amount", newValue: this.newValue }, ( error, id ) ->
		    	if error 
		    		sAlert.error( error.reason )
		    	else
		    		return
	validateIOUReason: ( doc, collection ) ->
		## No validation, really. Just log it
		Meteor.call 'editIou', doc, { fieldName: "reason", newValue: this.newValue }, ( error, id ) ->
			if error
				sAlert.error( error.reason )
			else
				return

Meteor.methods {eventsOnHooksInit: ->}