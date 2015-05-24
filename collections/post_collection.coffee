root = exports ? this
root.Posts = new (Meteor.Collection)('posts')
# Note: this will allow ALL users to insert, update, and delete Posts
Meteor.methods
  deletePost: (id) ->
    Posts.remove id
  newPost: (post, suite_id) ->
    post.createdAt = moment().format 'MMMM Do YYYY, h:mm:ss a'
    post_id = Posts.insert post
    suite = Suites.findOne suite_id                       #TODO: move this section to suite_collection
    if !(suite.post_ids?)                                            
      Suites.update suite_id, $set: {post_ids: [post_id]}
    else
      Suites.update suite_id, $push: {post_ids: post_id}
    post_id
  setImagePath: (post, id) ->
    post.updatedAt = moment().format 'MMMM Do YYYY, h:mm:ss a'
    Posts.update id, $set: {
      imagePath: post.imagePath
      lastEditor: post.lastEditor
      lastEdited: post.lastEdited
    }
    id
  initializePosts: (suite_id) ->
    post =
      authorId: "SuiteLife Team"
      lastEditor: "SuiteLife Team"
      lastEdited: moment().format 'MMMM Do YYYY, h:mm:ss a'
      pinned: false
      imagePath: null
      message: '<h1>suite rules</h1>'
    Meteor.call 'newPost', post, suite_id, (error) -> 
      if error
        return alert(error.reason)  

    post = 
      authorId: "SuiteLife Team"
      lastEditor: "SuiteLife Team"
      lastEdited: moment().format 'MMMM Do YYYY, h:mm:ss a'
      pinned: false
      imagePath: null
      message: '<h1>Welcome to Suite Life!</h1> <br> <h4>delete my text to remove me</h4>'
    Meteor.call 'newPost', post, suite_id, (error) -> 
      if error
        return alert(error.reason)
