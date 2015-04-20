Router.map ->
  @route 'postsList', path: '/posts/list'
  @route 'postNew',
    path: '/post/new'
    template: 'postNew'
  @route 'postEdit',
    path: '/post/:_id/edit'
    template: 'postEdit'
    data: ->
      { post: Posts.findOne(@params._id) }
  @route 'postDetail',
    path: '/post/:_id/detail'
    template: 'postDetail'
    data: ->
      { post: Posts.findOne(@params._id) }
  return