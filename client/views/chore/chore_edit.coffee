Template.choreEdit.events
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
      Router.go 'choreDetail', _id: id
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
        Router.go 'choresView'
        return
    return

  ## return back to the list view
  'click .cancel': (e) ->
    e.preventDefault()
    Router.go 'choresList'
    return