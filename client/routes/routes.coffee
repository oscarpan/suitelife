Router.route '/', ->
  # render the Home template with a custom data context
  @render 'Home'
  return

Router.route '/splash'

Router.route '/invite/:_id', ->
  @render '/splash'

Router.onBeforeAction ->
  if (/invite\//.exec Router.current().url)?        #override redirect for invites
    @next()
  else if !Meteor.userId()
    @redirect '/splash'
    @next()
  else if (!Suites.findOne users: Meteor.userId())  #if no suite has this user id in their 'users' array
    @render 'suite'
  else
    @next()
  return