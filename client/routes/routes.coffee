Router.route '/', -> 
  # render the Home template with a custom data context
  @render 'Home', data: title: 'My Title'
  return

####### DEPRECATED ##########

# when you navigate to "/one" automatically render the template named "One".
Router.route '/one'
# when you navigate to "/two" automatically render the template named "Two".
Router.route '/two'

Router.route '/splash'

Router.route '/exampleComponent', ->
	@render 'ExampleComponentWrapper'
	return

################################

Router.onBeforeAction ->
  if !Meteor.userId()
    @render 'splash'
  else
    @next()
  return