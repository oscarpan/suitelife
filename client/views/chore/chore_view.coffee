## for going to different pages
Template.choresView.events 
  'click .new': (e) ->
    e.preventDefault()
    Session.set 'activeModal', 'newChoreForm'
    Session.set 'startDay', 'today'
    $('#createChoreModal').modal('show')
    return

  'click .list': (e) ->
    e.preventDefault()
    Router.go 'choresList'
    return

  'hidden.bs.modal #createChoreModal': (e) ->
    $('#choreName').val('')
    $('#choreDesc').val('') 
    $('#choresModule').draggable(disabled:false)    
    Session.set 'activeModal', ''

  'shown.bs.modal #createChoreModal': (e) ->
    $('#choresModule').draggable(disabled:true)
    $('#choreName').focus()

Template.choreCalendar.helpers 
	## Fullcalendar options and event handling
  options: ->
  	{
      defaultView: 'basicWeek'
      header:
        center: 'basicWeek, month'
      ## Opens up modal with infomation on the date clicked
      dayClick: (date, jsEvent, view) ->
        Session.set 'activeModal', 'newChoreForm'

        # Get today's date - handle utc time issues
        todayDate = new Date
        todayDate.setDate todayDate.getDate() - 1
        
        # Check if date clicked is before today - invalid date -> set to today
        if moment(date).toDate() < todayDate
          Session.set 'startDay', 'today'
        else
          startDay = moment(date).format('YYYY/MM/DD')
          Session.set 'startDay', startDay
        $('#createChoreModal').modal('show')
        
      eventClick: (calEvent, jsEvent, view) ->
        ## Get the clicked event and set the data context for edit
        Session.set 'activeModal', 'editChoreForm'
        choreEvent = Chores.findOne(calEvent._id)
        Session.set 'choreEvent', choreEvent

        ## Event date session data for the datepicker to access 
        eventDate = moment(choreEvent.startDate).format('YYYY/MM/DD')
        Session.set 'startDay', eventDate
        $('#createChoreModal').modal('show')
        

      ## Let's get the chores!
      events: (start, end, timezone, callback) ->
        ## Create empty array to store events
        events = []
        ## Variable to pass events from collection to calendar
        choreEvents = Chores.find()
        ## For loop to pass each chore to events array
        choreEvents.forEach (evt) ->
          #Get completed, regular or past due color
          eventColor = getColor evt
          
          events.push
            id: evt._id
            title: evt.title
            start: evt.startDate
            color: eventColor
            allDay: true

        ## Callback to pass events to the calendar
        callback events
        return
    }
    
# Reactive calendar updates -- oooh aaaah
Template.choreCalendar.onRendered ->
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
  modalTitle: ->
    active = Session.get 'activeModal'
    if active == 'newChoreForm'
      'Create a New Chore'
    else if active == 'editChoreForm'
      'Edit a Chore'

getColor = (evt) ->
  date = new Date
  date.setDate date.getDate() - 1

  color = '#9987ca'
  if evt.startDate < date and not evt.completed
    color = '#d9534f'
  else if evt.completed
    color = '#5cb85c'
  color

