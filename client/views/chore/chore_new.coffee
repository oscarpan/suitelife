Template.newChoreForm.helpers
  users: ->
    if Session.get('suite')?
      Suites.findOne(Session.get('suite')._id).users
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name

Template.newChoreForm.events
  # new chore submission
  'submit form': (e) ->
    e.preventDefault()

    assignees = []
    assignees = $('#assignee').val()

    ## Find which reptition value is checked
    startDay = $('#datepicker').datepicker 'getDate'
    frequency = $(e.target).find('[name=repeat-freqs]').val()
    frequency = parseInt(frequency)
    
    freqNum = $(e.target).find('[name=freqNum]').val()
     ## Ensure frequency is a number
    if isNaN freqNum
      sAlert.warning "Chore frequency must be an integer value."
      return false
    ## Ensure input is a positve integer
    else if ( Number freqNum < 0 ) || ( Number freqNum % 1 != 0 )
      sAlert.warning "Chore frequency must be a positive integer."
      return false
    else if assignees == null
    	sAlert.warning "A person must be assigned to the chore."
    	return false
    if frequency == 0
    	if assignees.length > 1
    		sAlert.warning "A one-time event can only allow 1 person to be assigned."
    		return false
      freqNum = null

    ## object to send to new chore func
    chore =
      assignee: assignees[0]
      title: $(e.target).find('[name=choreName]').val()
      startDate: startDay
      description: $(e.target).find('[name=choreDesc]').val()
      completed: false

    freqString = freqToString frequency

    ## to store the new chore in collection  
    Meteor.call 'newChore', chore, frequency, freqString, freqNum, assignees, (error, id) ->
      if error
        sAlert.error(error.reason)
      $('#createChoreModal').modal 'hide'
      return
    return

  'change #repeat-freqs': (e) ->
    e.preventDefault()
    frequency = $('#repeat-freqs').val()
    if frequency == '0'
      $('#freqNum').attr 'disabled', true
     else
      $('#freqNum').attr 'disabled', false

Template.newChoreForm.onRendered ->
  startDay = Session.get 'startDay'
  $('#datepicker').datepicker 'setDate', startDay
  $('.selectpicker').selectpicker()



Template.dates.onRendered ->
  ## Loading options for the datepicker
  $('#datepicker').datepicker
    startDate: 'today'
    format: 'yyyy/mm/dd'

freqToString = (freq) ->
  if freq <= 1
    'd'
  else if freq == 7 or freq == 14
    'w'
  else if freq == 30
    'M'