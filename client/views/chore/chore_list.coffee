Template.choresList.helpers 
  chores: ->
    ## display chores in descending order
    Chores.find {}, sort: 
      startDate: 1
      createdAt: 1

Template.choreItem.events
  'click .listDetail': (e) ->
    e.preventDefault()
    choreEvent = Chores.findOne(@_id)
    Session.set 'activeModal', 'choreDetail'
    Session.set 'choreEvent', choreEvent
    $('#createChoreModal').modal('show').find('.modal-title').html('Chore Detail')

  'click .listDelete': (e) ->
    e.preventDefault()
    if confirm('Delete this Chore?')
      currentId = @_id
      Meteor.call 'deleteChore', currentId, (error, id) ->
        if error
          return alert(error.reason)
        return
    return

  'click .completed': (e) ->
    currentId = @_id
    Meteor.call 'completeChore', currentId, (error, id) ->
      if error
        return alert(error.reason)

Template.choreItem.helpers
  dateFormat: (date) ->
    moment(date).format('MM/DD/YY')
  freqString: (freq) ->
    if freq == 0
      'Once'
    else if freq == 1
      'Daily'
    else if freq == 7
      'Weekly'
    else if freq == 14
      'Bi-Weekly'
    else if freq == 30
      'Monthly'
  assignFormat: (assigneeId) ->
    assignee = Meteor.users.findOne assigneeId
    assignee.profile.first_name + " " + assignee.profile.last_name
  freqFormat: (freqNum) ->
    if freqNum == null
      'N/A'
    else
      freqNum
  completeColor: (completed, startDate) ->
    if completed
      "success"
    else
      date = new Date
      date.setDate date.getDate() - 1

      if startDate < date and not completed
        "danger"