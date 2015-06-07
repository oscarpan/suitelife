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
	getName: (id) ->
		usr = Meteor.users.findOne id
		if usr?
			return usr.profile['first_name']+' '+usr.profile['last_name']
		else
			return id
