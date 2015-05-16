Session.setDefault 'activeModal', 'newChoreForm'

## for going to different pages
Template.choresView.events 
  'click .new': (e) ->
    e.preventDefault()
    Session.set 'activeModal', 'newChoreForm'
    $('#datepicker').datepicker 'setDate', 'today'
    $('#createChoreModal').modal 'show'
    return

  'click .list': (e) ->
    e.preventDefault()
    Router.go 'choresList'
    return

  # needed to reset the modal - the datepicker doesn't like setting the session at the same time
  'hidden.bs.modal #createChoreModal': (e) ->
    e.preventDefault()
    Session.set 'activeModal', 'newChoreForm'

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
        startDay = moment(date).format('YYYY/MM/DD')
        $('#datepicker').datepicker 'setDate', startDay
        $('#createChoreModal').modal 'show'
        
      eventClick: (calEvent, jsEvent, view) ->
        ## Get the clicked event and set the data context for edit
        choreEvent = Chores.findOne(calEvent._id)
        Session.set 'activeModal', 'choreDetail'
        Session.set 'choreEvent', choreEvent
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
          freq = freqToString evt.frequency
          if evt.frequency > 0
            i = 0
            j = 0
            while i < evt.freqNum
              events.push
                id: evt._id
                title: evt.title
                start: moment(evt.startDate).add j, freq
                allDay: true
              if evt.frequency == '14'
                j++
              i++
              j++
            return
          else
            events.push
                id: evt._id
                title: evt.title
                start: evt.startDate
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

freqToString = (freq) ->
  console.log freq
  if freq <= '1'
    'd'
  else if freq == '7' or freq == '14'
    'w'
  else if freq == '30'
    'M'

