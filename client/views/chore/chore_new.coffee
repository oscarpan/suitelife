Template.newChoreForm.events
  # new chore submission
  'submit form': (e) ->
    e.preventDefault()

    ## Find which reptition value is checked
    startDay = $('#datepicker').datepicker 'getDate'
    frequencyInput = $(e.target).find('[name=repeat-freqs]').val()
    freqNumInput = $(e.target).find('[name=freqNum]').val()
    frequencyInput = parseInt(frequencyInput)
    if frequencyInput == 0
      freqNumInput = null

    ## object to send to new chore func
    chore =
      assignee: $(e.target).find('[name=assignee]').val()
      title: $(e.target).find('[name=choreName]').val()
      startDate: startDay
      frequency: frequencyInput
      freqNum: freqNumInput
      description: $(e.target).find('[name=choreDesc]').val()
      completed: false


    ## to store the new chore in collection  
    Meteor.call 'newChore', chore, (error, id) ->
      if error
        return alert(error.reason)
      $('#createChoreModal').modal 'hide'
      return
    return

  'change #repeat-freqs': (e) ->
    e.preventDefault()
    frequency = $('#repeat-freqs').val()
    if frequency == 0
      $('#freqNum').prop 'disabled', true
    else
      $('#freqNum').prop 'disabled', false    

Template.newChoreForm.helpers
  users: ->
    if Session.get('suite')?
      Suites.findOne(Session.get('suite')._id).users
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name

Template.newChoreForm.onRendered ->
  startDay = Session.get 'startDay'
  $('#datepicker').datepicker 'setDate', startDay

Template.dates.onRendered ->
  ## Loading options for the datepicker
  $('#datepicker').datepicker
    startDate: 'today'
    format: 'yyyy/mm/dd'

