Template.choresList.helpers 
  chores: ->
    ## display chores in descending order
    Chores.find {}, sort: createdAt: -1

Template.choreItem.events
  'click .listDetail': (e) ->
    e.preventDefault()
    choreEvent = Chores.findOne(@_id)
    Session.set 'activeModal', 'choreDetail'
    Session.set 'choreEvent', choreEvent
    $('#createChoreModal').modal 'show'

  'click .listDelete': (e) ->
    e.preventDefault()
    if confirm('Delete this Chore?')
      currentId = @_id
      Meteor.call 'deleteChore', currentId, (error, id) ->
        if error
          return alert(error.reason)
        return
    return

Template.choreItem.helpers
  dateFormat: (date) ->
    moment(date).format('MMMM Do')
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