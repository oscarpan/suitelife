##### POSTS #####

Template.postsList.events 
	'click .new': (e) ->
		e.preventDefault()
		post = 														
			authorId: Meteor.userId()
			lastEditor: Meteor.userId()
			lastEdited: moment().format 'MMMM Do YYYY, h:mm:ss a'
			pinned: false
			imagePath: null
			message: null
		Meteor.call 'newPost', post, Suites.findOne(users: Meteor.userId())._id, (error, id) ->
			if error
				sAlert.error(error.reason)
			#add the element to packery
			packery = $('.postsPackery').data().packery
			packery.appended($('.postsPackery').children().last())
	'click .delete' : (e) ->
		idNode = e.target.attributes.postId || e.target.parentNode.attributes.postId #might click on the icon vs the button
		Meteor.call 'deletePost', idNode.value, (error) ->
			if error
				sAlert.error(error.reason)	

Template.postsList.helpers 
	posts: ->
		Posts.find().fetch()

Template.Post.helpers
	getEmail: (id) ->
		usr = Meteor.users.findOne id
		if usr?
			return usr.emails[0].address
		else
			return id

##### UPLOADER #####

Template.Post.events 'click .clear': (e) ->
	e.preventDefault()
	post_id = e.target.attributes.post.value
	post = Posts.findOne post_id					#get the current post calling the upload
	post.imagePath = null
	post.lastEditor = Meteor.userId()
	post.lastEdited = moment().format 'MMMM Do YYYY, h:mm:ss a'
	Meteor.call 'setImagePath', post, post._id, (error) ->					#update the post's image path
		if error
			sAlert.error(error.reason)

Template.uploader.helpers
	myCallbacks: ->
		finished: (index, fileInfo, context) ->
			suite = Suites.findOne(users: Meteor.userId())		#TODO move to session variable
			post = Posts.findOne context.parent().parent().data._id					#get the current post calling the upload
																												#TODO remove old images
			Meteor.call 'uploadToSuite', fileInfo, suite._id, (error) ->		#upload the new image from the suite
				if error
					sAlert.error(error.reason)
			
			post.imagePath = fileInfo
			post.lastEditor = Meteor.userId()
			post.lastEdited = new Date()

			Meteor.call 'setImagePath', post, post._id, (error) ->					#update the post's image path
				if error
					sAlert.error(error.reason)
