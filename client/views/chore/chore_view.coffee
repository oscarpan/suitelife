Session.setDefault 'activeModal', 'newChoreForm'

## for going to different pages
Template.choresView.events 
  'click .new': (e) ->
    e.preventDefault()
    Session.set 'activeModal', 'newChoreForm'
    $('#createChoreModal').modal 'show'
    return
  'click .list': (e) ->
    e.preventDefault()
    Router.go 'choresList'
    return

Template.choreCalendar.helpers 
	## Fullcalendar options and event handling
  options: ->
  	{
      height: 300
      defaultView: 'basicWeek'
      ## Opens up modal with infomation on the date clicked
      dayClick: (date, jsEvent, view) ->
        Session.set 'activeModal', 'newChoreForm'
        $('#createChoreModal').modal 'show'
      eventClick: (calEvent, jsEvent, view) ->
        ## Get the clicked event and set the data context for edit
        choreEvent = Chores.findOne(calEvent._id)
        Session.set 'activeModal', 'editChoreForm'
        Session.set 'choreData', choreEvent
        $('#createChoreModal').modal 'show'

      ## Let's get the chores!
      events: (start, end, timezone, callback) ->
        ## Create empty array to store events
        events = []
        ## Variable to pass events from collection to calendar
        choreEvents = Chores.find()
        ## For loop to pass each chore to events array
        choreEvents.forEach (evt) ->
          ## console.log evt
          events.push
            id: evt._id
            title: evt.title
            start: evt.start
            end: evt.end
            allDay: evt.allDay
          return

        ## Callback to pass events to the calendar
        callback events
        return
    }
    
# Reactive calendar updates -- oooh aaaah
Template.choreCalendar.rendered = ->
  fc = @$('.fc')
  @autorun ->
    #1) trigger event re-rendering when the collection is changed in any way
    #2) find all, because we've already subscribed to a specific range
    Chores.find()
    fc.fullCalendar 'refetchEvents'
    return
  return

Template.createChore.helpers 
  # getter for creating state
  activeModal: ->
    Session.get 'activeModal'

