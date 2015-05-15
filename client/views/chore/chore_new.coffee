Template.newChoreForm.events
  # new chore submission
  'submit form': (e) ->
    e.preventDefault()

    ## Find which reptition value is checked

    startDay = Session.get 'choreData'
    ## object to send to new chore func
    chore = 
      title: $(e.target).find('[name=choreName]').val()
      #choreDays: choredays
      choreAssign: $(e.target).find('[name=choreAssign]').val()
      allDay: true
      start: startDay

    ## to store the new chore in collection  
    Meteor.call 'newChore', chore, (error, id) ->
      if error
        return alert(error.reason)
      Session.set 'activeModal', 'choreDetail'
      $('#createChoreModal').modal 'hide'
      $('#detailChoreModal').modal 'show'
      return
    return

Template.newChoreForm.onRendered ->
	click = Session.get 'choreData'
	console.log click

	$('#datetimepicker').datetimepicker
		minDate: '0'
		minTime: '0'
		inline: true
		value: click

Template.newChoreForm.helpers
  choreData: ->
    Session.get 'choreData'


