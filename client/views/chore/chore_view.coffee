Template.choreCalendar.helpers 
  ## Fullcalendar options and event handling
  options: ->
    {
      defaultView: 'basicWeek'
      header:
        left: 'basicWeek, month'
        center: 'title'
      ## Opens up modal with infomation on the date clicked
      dayClick: (date, jsEvent, view) ->
        Session.set 'activeModal', 'newChoreForm'
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

          # Each event is pushed into the array   
          events.push
            id: evt._id
            title: evt.title
            start: evt.startDate
            color: eventColor
            allDay: true
            assignee: evt.assignee

        ## Callback to pass events to the calendar
        callback events
        return
      # Adds the lower "boxed" section to the event that shows the assignee
      eventRender: (event, element) ->
        assignee = Meteor.users.findOne event.assignee
        if assignee?
          assigneeName = (assignee.profile.first_name)
        element.find('.fc-title').append '<br/><br/><div id="assignDiv" align="right">' + assigneeName + '</div>'
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


Template.choresView.events
  # Opens up the modal for creating a new chore
  'click .new': (e) ->
    e.preventDefault()
    Session.set 'activeModal', 'newChoreForm'
    Session.set 'startDay', 'today'
    $('#createChoreModal').modal('show')
    return

  # Clears the modal forms when the modal is dismissed/disables dragging
  'hidden.bs.modal #createChoreModal': (e) ->
    $('#choreName').val('')
    $('#choreDesc').val('') 
    $('#choresModule').draggable(disabled:false)    
    Session.set 'activeModal', ''

  # Focuses the chore name and allows dragging again
  'shown.bs.modal #createChoreModal': (e) ->
    $('#choresModule').draggable(disabled:true)
    $('#choreName').focus()


Template.createChore.helpers 
  # getter for whether we create or edit
  activeModal: ->
    Session.get 'activeModal'
  # Dynamically sets the title on the modal based on edit or new
  modalTitle: ->
    active = Session.get 'activeModal'
    if active == 'newChoreForm'
      'Create a New Chore'
    else if active == 'editChoreForm'
      'Edit a Chore'

# Sets the colors for the events - red = past due, green = complete, blue = the rest
getColor = (evt) ->
  date = new Date
  date.setDate date.getDate() - 1

  color = '#3B9191'
  if evt.startDate < date and not evt.completed
    color = '#d9534f'
  else if evt.completed
    color = '#5cb85c'
  color