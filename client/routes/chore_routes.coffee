## routes for chore views 
Router.map ->
  @route 'choresView',
    path: '/chores/view'
  @route 'choresList',
    path: '/chores/list'
  @route 'choreEdit',
    path: '/chore/:_id/edit'
    template: 'choreEdit'
    data: ->
      { chore: Chores.findOne(@params._id) }
  @route 'choreDetail',
    path: '/chore/:_id/detail'
    template: 'choreDetail'
    data: ->
      { chore: Chores.findOne(@params._id) }
  return