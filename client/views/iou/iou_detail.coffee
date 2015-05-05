Template.iouDetail.events
  'click .edit-iou': (e) ->
    e.preventDefault()
    Router.go 'iouEdit', _id: @_id
    return
  'click .list-iou': (e) ->
    e.preventDefault()
    Router.go 'iousList'
    return