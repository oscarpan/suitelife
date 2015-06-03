Template.editChoreForm.helpers
  choreEvent: ->
    # Get the data context for the edit
    choreEvent = Session.get 'choreEvent'
  users: ->
    if Suites.findOne(users: Meteor.userId())?
      Suites.findOne(users: Meteor.userId()).users
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name
  selected: (assignee, current) ->
    return assignee == current

Template.editChoreForm.events
  ## edit form submission
  'submit form': (e) ->
    e.preventDefault()
    currentId = @_id
    startDay = $('#datepicker').datepicker 'getDate'

    ## edit object
    choreEdits =
      assignee: $(e.target).find('[name=assignee]').val()
      title: $(e.target).find('[name=choreName]').val()
      startDate: startDay
      description: $(e.target).find('[name=choreDesc]').val()

    ## edit function for collection managing
    Meteor.call 'editChore', choreEdits, currentId, (error, id) ->
      if error
        sAlert.error(error.reason)
      $('#createChoreModal').modal 'hide'
      return
    return

   ## delete the function from collection 
  'click .delete': (e) ->
    e.preventDefault()
    deleteChore = Chores.findOne(@_id)
    Session.set 'deleteChore', deleteChore
    Tracker.flush()   # Force an update or the modal won't find the data correctly
    $('#deletedChoreModal').modal 'show'

  'change #repeat-freqs': (e) ->
    e.preventDefault()
    frequency = $('#repeat-freqs').val()
    if frequency == '0'
      $('#freqNum').attr 'disabled', true
    else
      $('#freqNum').attr 'disabled', false  

Template.editChoreForm.onRendered ->
  startDay = Session.get 'startDay'
  $('#datepicker').datepicker 'setDate', startDay
  $('.selectpicker').selectpicker()

