Router.route '/', -> 
  # render the Home template with a custom data context
  @render 'Home', data: title: 'My Title'
  return

Router.route '/splash'

Router.onBeforeAction ->
  if !Meteor.userId()
    @render 'splash'
  else if !(Meteor.user().suite)
    @render 'suite'
  else
    @next()
  return