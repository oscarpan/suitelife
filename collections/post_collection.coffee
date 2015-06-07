root = exports ? this
root.Posts = new (Meteor.Collection)('posts')
# Note: this will allow ALL users to insert, update, and delete Posts
Meteor.methods
  deletePost: (id) ->
    Posts.remove id
    #remove id from suite
    suite = (Suites.findOne users: Meteor.userId())
    index = suite.post_ids.indexOf(id)
    if (index > -1) 
      suite.post_ids.splice(index, 1);
      Suites.update suite._id, $set: {post_ids: suite.post_ids}
  newPost: (post, suite_id) ->
    post.createdAt = moment().subtract(7,'hours').format 'MMMM Do YYYY, h:mm:ss a'
    post_id = Posts.insert post
    suite = Suites.findOne suite_id                       #TODO: move this section to suite_collection
    if !(suite.post_ids?)                                            
      Suites.update suite_id, $set: {post_ids: [post_id]}
    else
      Suites.update suite_id, $push: {post_ids: post_id}
    post_id
  initializePosts: (suite_id) ->
    post =
      authorId: "sweety"
      lastEditor: "Sweety The Cat"
      lastEdited: moment().subtract(7,'hours').format 'MMMM Do YYYY, h:mm:ss a'
      message: '<font face="Lucida Grande" size="4">SUITE RULES: </font><div><ul><li><font size="2">use inside voices</font></li><li><font size="2">be respectful</font></li><li><font size="2">be helpful</font></li><li><font size="2">be appreciative - say thank you!</font></li><li><font size="2">look out for your family</font></li><li><font size="2">communicate - use your words</font></li></ul></div>'
    Meteor.call 'newPost', post, suite_id, (error) -> 
      if error
        sAlert.error(error.reason)  
    post = 
      authorId: "sweety"
      lastEditor: "Sweety The Cat"
      lastEdited: moment().subtract(7,'hours').format 'MMMM Do YYYY, h:mm:ss a'
      message: 'Welcome to Suite Life!'
    Meteor.call 'newPost', post, suite_id, (error) -> 
      if error
        sAlert.error(error.reason)
