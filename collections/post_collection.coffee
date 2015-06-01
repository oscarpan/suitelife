root = exports ? this
root.Posts = new (Meteor.Collection)('posts')
# Note: this will allow ALL users to insert, update, and delete Posts
Meteor.methods
  deletePost: (id) ->
    Posts.remove id
    Meteor.call 'updatePostSubscription'
  newPost: (post, suite_id) ->
    post.createdAt = moment().format 'h:mm on MM/DD'
    post_id = Posts.insert post
    suite = Suites.findOne suite_id                       #TODO: move this section to suite_collection
    if !(suite.post_ids?)                                            
      Suites.update suite_id, $set: {post_ids: [post_id]}
    else
      Suites.update suite_id, $push: {post_ids: post_id}
    Meteor.call 'updatePostSubscription'
    post_id
  setImagePath: (post, id) ->
    post.updatedAt = moment().format 'h:mm on MM/DD'
    Posts.update id, $set: {
      imagePath: post.imagePath
      lastEditor: post.lastEditor
      lastEdited: post.lastEdited
    }
    id
  initializePosts: (suite_id) ->
    post =
      authorId: "sweety"
      lastEditor: "Sweety The Cat"
      lastEdited: moment().format 'h:mm on MM/DD'
      pinned: false
      imagePath: null
      message: '<font face="Lucida Grande" size="4">SUITE RULES: </font><div><ul><li><font size="2">use inside voices</font></li><li><font size="2">be respectful</font></li><li><font size="2">be helpful</font></li><li><font size="2">be appreciative - say thank you!</font></li><li><font size="2">look out for your family</font></li><li><font size="2">communicate - use your words</font></li></ul></div>'
    Meteor.call 'newPost', post, suite_id, (error) -> 
      if error
        sAlert.error(error.reason)  
    post = 
      authorId: "sweety"
      lastEditor: "Sweety The Cat"
      lastEdited: moment().format 'h:mm on MM/DD'
      pinned: false
      imagePath: null
      message: 'Welcome to Suite Life!'
    Meteor.call 'newPost', post, suite_id, (error) -> 
      if error
        sAlert.error(error.reason)
  updatePostSubscription: ->
    if Meteor.isClient
      suite = Suites.findOne users: Meteor.userId()
      Meteor.subscribe 'posts', suite.post_ids
