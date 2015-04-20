class ExampleComponent extends BlazeComponent
  # Register a component so that it can be included in templates. It also
  # gives the component the name. The convention is to use the class name.
  @register 'ExampleComponent'

  # Which template to use for this component.
  template: ->
    # Convention is to name the template the same as the component.
    'ExampleComponent'

  # Life-cycle hook to initialize component's state.
  onCreated: ->
    @counter = new ReactiveVar 0

  # Mapping between events and their handlers.
  events: -> [
    # You could inline the handler, but the best is to make
    # it a method so that it can be extended later on.
    'click .increment': @onClick
  ]

  onClick: (event) ->
    @counter.set @counter.get() + 1

  # Any component's method is available as a template helper in the template.
  customHelper: ->
    if @counter.get() > 10
      "Too many times"
    else if @counter.get() is 10
      "Just enough"
    else
      "Click more"