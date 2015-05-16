Template.editChoreForm.events
  ## edit form submission
  'submit form': (e) ->
    e.preventDefault()
    currentId = @_id
    
    ## edit object
    choreEdits = 
      assignee: $(e.target).find('[name=assignee]').val()
      title: $(e.target).find('[name=choreName]').val()
      frequency: $(e.target).find('[name=repeat-freqs]:checked').val()
      
      

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
      console.log currentId
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
    Suites.findOne({ users: Meteor.userId() }).users

  getUserName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name



