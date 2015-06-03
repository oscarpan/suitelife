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
  if Router.current().route.getName() != 'invite'
    if !Meteor.userId()                #are you logged in?
      @redirect '/splash'
    else if Router.current().path == Router.path('splash')    #are you on the wrong page?
      @redirect '/'
  else
    if Meteor.userId() # check for suite in the future or associate suite
      @redirect '/'
  @next
  return