Router.route '/', ->
  @render 'Home'

Router.route '/splash'

Router.route '/invite/:_id', ->
  @render '/splash'

Router.onAfterAction ->
  if !Meteor.userId()                #are you logged in?
    @redirect '/splash'
  else if !Session.get('suite')      #are you logged in w/o a suite?
    Session.setAuth 'suite', (Suites.findOne users: Meteor.userId())
    @redirect '/'
  else if Router.current().path == Router.path('splash')    #are you on the wrong page?
    @redirect '/'
  @next
  return