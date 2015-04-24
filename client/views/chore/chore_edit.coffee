Template.choreEdit.events
  'submit form': (e) ->
    e.preventDefault()
    currentId = @_id

    choredays = []
    $('input[name=choreDays]:checked').each ->
      choredays.push $(this).val()
      return
    repeat = if $('#choreRepeat-0').prop('checked') then 'Weekly' else 'Once'
    choreEdits = 
      choreName: $(e.target).find('[name=choreName]').val()
      choreDays: choredays
      choreRepeat: repeat
      choreAssign: $(e.target).find('[name=choreAssign]').val()
    Meteor.call 'editChore', choreEdits, currentId, (error, id) ->
      if error
        return alert(error.reason)
      Router.go 'choreDetail', _id: id
      return
    return
  'click .delete': (e) ->
    e.preventDefault()
    if confirm('Delete this Chore?')
      currentId = @_id
      Meteor.call 'deleteChore', currentId, (error, id) ->
        if error
          return alert(error.reason)
        Router.go 'choresList'
        return
    return
  'click .cancel': (e) ->
    e.preventDefault()
    Router.go 'choresList'
    return