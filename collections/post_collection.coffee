root = exports ? this
root.Posts = new (Meteor.Collection)('posts')
# Note: this will allow ALL users to insert, update, and delete Posts
Meteor.methods
  deletePost: (id) ->
    Posts.remove id
    return
  newPost: (post) ->
    post.createdAt = (new Date).getTime()
    id = Posts.insert(post)
    id
  editPost: (post, id) ->
    post.updatedAt = (new Date).getTime()
    Posts.update id, $set: post
    id
  setImagePath: (post, id) ->
    post.updatedAt = (new Date).getTime()
    Posts.update id, $set: {
      imagePath: post.imagePath
      lastEditor: post.lastEditor
      lastEdited: post.lastEdited
    }
    id