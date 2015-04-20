Template.postsList.helpers posts: ->
  Posts.find {}, sort: createdAt: -1
Template.postsList.events 'click .new': (e) ->
  e.preventDefault()
  Router.go 'postNew'
  return
