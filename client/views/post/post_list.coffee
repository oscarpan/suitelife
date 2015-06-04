##### POSTS #####

Template.postsList.onCreated ->

	# 1. Initialization
	instance = this
	# initialize the reactive variables
	instance.post_ids = new ReactiveVar([])
	instance.postsContainer = $('.postsPackery').packery(
		columnWidth: 60
		gutter: 15
		transitionDuration: 0
	)		

	window.setInterval((->
		instance.postsContainer.packery('destroy')
		instance.postsContainer = $('.postsPackery').packery(
			columnWidth: 60
			gutter: 15
			transitionDuration: 0
		)), 250)

	# 2. Autorun
	# will re-run when the reactive variables changes
	@autorun ->
		# get the limit
		suite = (Suites.findOne users: Meteor.userId())
		if suite
			instance.post_ids.set(suite.post_ids)
			# subscribe to the posts publication
		subscription = instance.subscribe('posts', instance.post_ids.get())
		# if subscription is ready, set limit to newLimit

	# 3. Cursor
	instance.posts = ->
		return Posts.find {}

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
		instance = Template.instance()
		Meteor.call 'deletePost', idNode.value, (error) ->
			if error
				sAlert.error(error.reason)	

Template.postsList.helpers 
	posts: ->
		Template.instance().posts()

Template.Post.helpers
	getEmail: (id) ->
		usr = Meteor.users.findOne id
		if usr?
			return usr.emails[0].address
		else
			return id

#Template.Post.onRendered ->
#	Template.instance().parent().post_ids.set((Suites.findOne users: Meteor.userId()).post_ids)
	
#Template.Post.onDestroyed ->
#	Template.instance().parent().post_ids.set((Suites.findOne users: Meteor.userId()).post_ids)


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
