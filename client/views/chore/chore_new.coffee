Template.choreNew.events
  'submit form': (e) ->
    e.preventDefault()
    choredays = []
    $('input[name=choreDays]:checked').each ->
      choredays.push $(this).val()
      return
    repeat = if $('#choreRepeat-0').prop('checked') then 'Weekly' else 'Once'
    chore = 
      title: $(e.target).find('[name=choreName]').val()
      choreDays: choredays
      choreRepeat: repeat
      choreAssign: $(e.target).find('[name=choreAssign]').val()
      allDay: true
      start: new Date()
    Meteor.call 'newChore', chore, (error, id) ->
      if error
        return alert(error.reason)
      Router.go 'choreDetail', _id: id
      return
    return