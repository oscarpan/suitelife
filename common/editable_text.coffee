EditableText.registerCallbacks 
	whoDunnitPosts: (doc, collection) ->
		Posts.update doc._id, $set: 
			lastEditor: Meteor.userId()
			lastEdited: moment().format 'MMMM Do YYYY, h:mm:ss a'

Meteor.methods {eventsOnHooksInit: ->}