Router.route '/', ->
  @render 'Home'

Router.route '/splash'

Router.map ->
  @route 'invite',
    path: '/invite/:_id'
    template: 'splash'
    data: ->
      { suite: Suites.findOne(@params._id) }
  return

Router.onAfterAction ->
  if Meteor.userId() # check for suite in the future or associate suite
    @redirect '/'
  else if Router.current().route.getName() != 'invite'
    @redirect '/splash'
  @next
  return