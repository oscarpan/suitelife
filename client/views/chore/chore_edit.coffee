Template.editChoreForm.events
  ## edit form submission
  'submit form': (e) ->
    e.preventDefault()
    currentId = @_id

    ## array for days of the week
    choredays = []
    $('input[name=choreDays]:checked').each ->
      choredays.push $(this).val()
      return
    ## find frequency value
    repeat = if $('#choreRepeat-0').prop('checked') then 'Weekly' else 'Once'
    
    ## edit object
    choreEdits = 
      title: $(e.target).find('[name=choreName]').val()
      choreDays: choredays
      choreRepeat: repeat
      choreAssign: $(e.target).find('[name=choreAssign]').val()
      allDay: true
      start: new Date()

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
    choreEvent = Session.get('choreData')



