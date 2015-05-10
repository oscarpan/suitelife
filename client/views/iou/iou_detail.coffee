Template.iouDetail.helpers
  date: (date) ->
    moment(date).format('MMMM Do YYYY, h:mm:ss a')

Template.iouDetail.events
  'click .edit-iou': (e) ->
    e.preventDefault()
    Router.go 'iouEdit', _id: @_id
    return
  'click .list-iou': (e) ->
    e.preventDefault()
    Router.go 'iousList'
    return