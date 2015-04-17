Router.route '/', -> 
  # render the Home template with a custom data context
  @render 'Home', data: title: 'My Title'
  return
# when you navigate to "/one" automatically render the template named "One".
Router.route '/one'
# when you navigate to "/two" automatically render the template named "Two".
Router.route '/two'

Router.route '/exampleComponent', ->
	@render 'ExampleComponentWrapper'
	return