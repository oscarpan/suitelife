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
      frequency: $(e.target).find('[name=repeat-freqs]:checked').val()
      freqNum: $(e.target).find('[name=freqNum]').val()   

    ## edit function for collection managing
    Meteor.call 'editChore', choreEdits, currentId, (error, id) ->
      if error
        return alert(error.reason)
      $('#createChoreModal').modal 'hide'
      return
    return

   ## delete the function from collection 
  'click .delete': (e) ->
    e.preventDefault()
    if confirm('Delete this Chore?')
      currentId = @_id
      Meteor.call 'deleteChore', currentId, (error, id) ->
        if error
          return alert(error.reason)
        $('#createChoreModal').modal 'hide'
        return
    return

Template.editChoreForm.helpers
  choreEvent: ->
    # Get the data context for the edit
    choreEvent = Session.get 'choreEvent'
  users: ->
    if Session.get('suite')?
      Suites.findOne(Session.get('suite')._id).users
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name



