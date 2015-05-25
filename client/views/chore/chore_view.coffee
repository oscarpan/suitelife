## for going to different pages
Template.choresView.events 
  'click .new': (e) ->
    e.preventDefault()
    Session.set 'activeModal', 'newChoreForm'
    Session.set 'startDay', 'today'
    $('#choresModule').draggable(disabled:true)
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
    $('#choreName').focus()

Template.choreCalendar.helpers 
	## Fullcalendar options and event handling
  options: ->
  	{
      height: 300
      defaultView: 'basicWeek'
      header:
        center: 'basicWeek, month'
      ## Opens up modal with infomation on the date clicked
      dayClick: (date, jsEvent, view) ->
        Session.set 'activeModal', 'newChoreForm'

        clickDate = new Date
        clickDate.setDate clickDate.getDate() - 1
        
        if moment(date).toDate() < clickDate
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
          eventColor = getColor evt
          #if evt.frequency > 0
           # repeating = 0
            #incDay = 0
            #while repeating < evt.freqNum
             # events.push
              #  id: evt._id
               # title: evt.title
                #start: moment(evt.startDate).add incDay, freq
                #color: eventColor
                #allDay: true
              #if evt.frequency == 14
               # incDay++
              #repeating++
              #incDay++
            #return
          #else
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

