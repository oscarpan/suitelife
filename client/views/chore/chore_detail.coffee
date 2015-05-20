Template.choreDetail.events
  'submit form': (e) ->
    e.preventDefault()
    currentId = @_id
    
    startDay = $('#datepicker').datepicker 'getDate'
    ## edit object
    choreEdits =
      assignee: $(e.target).find('[name=assignee]').val()
      title: $(e.target).find('[name=choreName]').val()
      startDate: startDay
      frequency: $(e.target).find('[name=repeat-freqs]:checked').val()
      freqNum: $(e.target).find('[name=freqNum]').val()      

    ## edit function for collection managing
    Meteor.call 'editChore', choreEdits, currentId, (error, id) ->
      if error
        return alert(error.reason)
      $('#createChoreModal').modal 'hide'
      return
    return

Template.choreDetail.helpers
  users: ->
    if Session.get('suite')?
      Suites.findOne(Session.get('suite')._id).users
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name
  choreEvent: ->
    Session.get 'choreEvent'
  date: (date) ->
    moment(date).format('MMMM Do YYYY, h:mm:ss a')
  assignFormat: (assigneeId) ->
    assignee = Meteor.users.findOne assigneeId
    assignee.profile.first_name + " " + assignee.profile.last_name
  freqString: (freq) ->
    if freq == '0'
      'Once'
    else if freq == '1'
      'Daily'
    else if freq == '7'
      'Weekly'
    else if freq == '14'
      'Bi-Weekly'
    else if freq == '30'
      'Monthly'
    
Template.choreDetail.onRendered ->
  $('#datepicker').datepicker
    format: 'yyyy/mm/dd'