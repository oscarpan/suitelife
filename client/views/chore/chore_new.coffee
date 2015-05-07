Template.newChoreForm.events
  # new chore submission
  'submit form': (e) ->
    e.preventDefault()

    ## days of the week stored in an array - get value from checkbox
    choredays = []
    $('input[name=choreDays]:checked').each ->
      choredays.push $(this).val()
      return

    ## Find which reptition value is checked
    repeat = if $('#choreRepeat-0').prop('checked') then 'Weekly' else 'Once'
    
    ## object to send to new chore func
    chore = 
      title: $(e.target).find('[name=choreName]').val()
      choreDays: choredays
      choreRepeat: repeat
      choreAssign: $(e.target).find('[name=choreAssign]').val()
      allDay: true
      start: new Date()

    ## to store the new chore in collection  
    Meteor.call 'newChore', chore, (error, id) ->
      if error
        return alert(error.reason)
      Session.set 'activeModal', 'choreDetail'
      $('#createChoreModal').modal 'hide'
      $('#detailChoreModal').modal 'show'
      return
    return