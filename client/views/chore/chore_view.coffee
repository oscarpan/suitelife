## For template toggling
Session.setDefault 'showCreateChore', false

## for going to different pages
Template.choresView.events 
  'click .new': (e) ->
	  e.preventDefault()
	  Router.go 'choreNew'
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
        Session.set 'showCreateChore', true
        $('#createChoreModal').modal 'show'
        createChoreEvent date
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
   ## getter for creating state
  showCreateChore: ->
    Session.get 'showCreateChore'
 
createChoreEvent = (date) ->
  ## move submit function form new/edit here?
  return