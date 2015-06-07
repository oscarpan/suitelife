Template.newChoreForm.helpers
  # List of the users
  users: ->
    if Suites.findOne(users: Meteor.userId())?
      Suites.findOne(users: Meteor.userId()).users
  # A string of the users name
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name

Template.newChoreForm.events
  # new chore submission
  'submit form': (e) ->
    e.preventDefault()

    # Array of all possibly selected assignees
    assignees = []
    assignees = $('#assignee').val()

    ## Find which reptition value is checked
    startDay = $('#datepicker').datepicker 'getDate'
    frequency = $(e.target).find('[name=repeat-freqs]').val()
    frequency = parseInt(frequency)
    
    freqNum = $(e.target).find('[name=freqNum]').val()
    ## Ensure frequency is a number
    if isNaN freqNum
      sAlert.error "Chore frequency must be an integer value."
      return false
    ## Ensure input is a positve integer
    else if ( Number freqNum < 0 ) || ( Number freqNum % 1 != 0 )
      sAlert.error "Chore frequency must be a positive integer."
      return false
    ## Ensure input is not greater than 31
    else if (Number freqNum > 31)
      sAlert.error "31 is the maximum number of times for a repeat at once"
      return false
    ## Ensure that an assignee has been selected
    if assignees == null
    	sAlert.error "A person must be assigned to the chore."
    	return false
    ## If once is selected, than only one person can be assigned to that chore
    if frequency == 0
    	if assignees.length > 1
    		sAlert.error "A one-time event can only allow 1 person to be assigned."
    		return false
      freqNum = null

    ## object to send to new chore func
    chore =
      assignee: assignees[0]
      title: $(e.target).find('[name=choreName]').val()
      startDate: startDay
      description: $(e.target).find('[name=choreDesc]').val()
      completed: false

    # Turn the frequency into a string that moment can understand
    freqString = freqToString frequency

    ## to store the new chore in collection  
    Meteor.call 'newChore', chore, frequency, freqString, freqNum, assignees, (error, id) ->
      if error
        sAlert.error(error.reason)
      $('#createChoreModal').modal 'hide'
      return
    return

  # Disables the number of times repeating when once is selected
  'change #repeat-freqs': (e) ->
    e.preventDefault()
    frequency = $('#repeat-freqs').val()
    if frequency == '0'
      $('#freqNum').attr 'disabled', true
     else
      $('#freqNum').attr 'disabled', false

Template.newChoreForm.onRendered ->
  # Set up datepicker and multiselect
  startDay = Session.get 'startDay'
  $('#datepicker').datepicker 'setDate', startDay
  $('.selectpicker').selectpicker()

Template.dates.onRendered ->
  ## Loading options for the datepicker
  $('#datepicker').datepicker
    format: 'yyyy/mm/dd'

# Moment needs these chars for adding to a date
freqToString = (freq) ->
  if freq <= 1
    'd'
  else if freq == 7 or freq == 14
    'w'
  else if freq == 30
    'M'