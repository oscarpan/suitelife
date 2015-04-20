Router.route '/', -> 
  # render the Home template with a custom data context
  @render 'Home', data: title: 'My Title'
  return
# when you navigate to "/one" automatically render the template named "One".
Router.route '/one'
# when you navigate to "/two" automatically render the template named "Two".
Router.route '/two'

Router.route '/splash'

Router.route '/exampleComponent', ->
	@render 'ExampleComponentWrapper'
	return


Router.onBeforeAction ->
  if !Meteor.userId()
    @render 'splash'
  else
    @next()
  return

# Router.configure
#   layoutTemplate: 'defaultLayout'
#   onBeforeAction: (pause) ->	#hooks into lifecycle to switch
#     if !Meteor.user()
#       # render the login template but keep the url in the browser the same
#       @router.layout 'loginLayout'
#       @render 'splash'
#       # pause the rest of the before hooks and the action function
#       pause()
#     else
#       #Here we have to change the layoutTemplate back to the default
#       @router.layout 'defaultLayout'
#     return