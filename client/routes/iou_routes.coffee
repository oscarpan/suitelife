Router.map ->
  @route 'iousList',
    path: '/ious/list'
  @route 'iouNew',
    path: '/iou/new'
    template: 'iouNew'
  @route 'iouEdit',
    path: '/iou/:_id/edit'
    template: 'iouEdit'
    data: ->
      { iou: Ious.findOne(@params._id) }
  @route 'iouDetail',
    path: '/iou/:_id/detail'
    template: 'iouDetail'
    data: ->
      { iou: Ious.findOne(@params._id) }
  return