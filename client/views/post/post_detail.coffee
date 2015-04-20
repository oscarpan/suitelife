Template.postDetail.events
  'click .edit-post': (e) ->
    e.preventDefault()
    Router.go 'postEdit', _id: @_id
    return
  'click .list-post': (e) ->
    e.preventDefault()
    Router.go 'postsList'
    return