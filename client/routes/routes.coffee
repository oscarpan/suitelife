Router.route '/', -> 
  # render the Home template with a custom data context
  @render 'Home', data: title: 'My Title'
  return

Router.route '/splash'

Router.onBeforeAction ->
  if !Meteor.userId()
    @render 'splash'
  else if (!Suites.findOne users: Meteor.userId())  #if no suite has this user id in their 'users' array
    @render 'suite'
  else
    @next()
  return

Router.onAfterAction ->