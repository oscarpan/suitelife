Template.postsList.helpers 
	posts: ->
		Posts.find {}, sort: lastEdited: -1

Template.Post.rendered = ->
  $('[data-toggle="tooltip"]').tooltip placement: 'top'
  return

	Template.Post.rendered = ->
		$('[data-toggle="popover"]').popover()
		return

Template.postsList.events 'click .new': (e) ->
	e.preventDefault()
	post = newPosts()
	Meteor.call 'newPost', post, (error, id) ->
		if error
			return alert(error.reason)
	#todo: editing on create
	return

Template.Post.helpers
	getEmail: (id) ->
		usr = Meteor.users.findOne id
		if (usr)
			return usr.emails[0].address
		return

Template.Post.events 'click .clear': (e) ->
	e.preventDefault()
	post_id = e.target.attributes.post.value
	post = Posts.findOne post_id					#get the current post calling the upload
	post.imagePath = null
	post.lastEditor = Meteor.userId()
	post.lastEdited = new Date()
	Meteor.call 'setImagePath', post, post._id, (error) ->					#update the post's image path
		if error
			return alert(error.reason)

EditableText.registerCallbacks																				#TODO fix registration
	whodunnit: (doc, collection) ->
		doc = _.extend doc, lastEdited: new Date()
		doc = _.extend doc, lastEditor: Meteor.userId()
		doc

Template.newPost.helpers 	
	newPosts: ->	#initialize a new post for 'context=newPosts'
		{
			authorId: Meteor.userId()
			lastEditor: Meteor.userId()
			lastEdited: new Date()
			pinned: false
			imagePath: null
			message: null
		}

Template.uploader.helpers
	myCallbacks: ->
		finished: (index, fileInfo, context) ->
			suite = Suites.findOne(users: Meteor.userId())									#TODO move to session variable
			post = Posts.findOne context.parent().parent().data._id					#get the current post calling the upload
																																			#TODO remove old images
			Meteor.call 'uploadToSuite', fileInfo, suite._id, (error) ->		#upload the new image from the suite
				if error
					return alert(error.reason)
			
			post.imagePath = fileInfo
			post.lastEditor = Meteor.userId()
			post.lastEdited = new Date()

			Meteor.call 'setImagePath', post, post._id, (error) ->					#update the post's image path
				if error
					return alert(error.reason)
