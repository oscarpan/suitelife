Template.postsList.helpers 
	posts: ->
  	Posts.find {}, sort: createdAt: -1

Template.Post.helpers
	getEmail: (id) ->
		usr = Meteor.users.findOne id
		usr.emails[0].address
  
Template.newPost.helpers 
  newPosts: ->
	  {
	  	authorId: Meteor.userId()
	  	lastEditor: Meteor.userId()
	  	lastEdited: new Date()
	  	pinned: false
	  	imagePath: null
	  	message: null
	  }

Template.postsList.events 'click .new': (e) ->
  e.preventDefault()
  post = newPosts()
  Meteor.call 'newPost', post, (error, id) ->
    if error
      return alert(error.reason)
  #todo: simulate click by id
  return

