Template.newChoreForm.events
  # new chore submission
  'submit form': (e) ->
    e.preventDefault()

    ## Find which reptition value is checked
    startDay = $('#datepicker').datepicker 'getDate'
    ## object to send to new chore func
    chore =
      assignee: $(e.target).find('[name=assignee]').val()
      title: $(e.target).find('[name=choreName]').val()
      startDate: startDay
      frequency: $(e.target).find('[name=repeat-freqs]:checked').val()
      freqNum: $(e.target).find('[name=freqNum]').val()
      
    ## to store the new chore in collection  
    Meteor.call 'newChore', chore, (error, id) ->
      if error
        return alert(error.reason)
      $('#createChoreModal').modal 'hide'
      return
    return

  'click input[type=radio]': (e) ->
    freq = $(e.target).val()
    if freq == '0'
      $('#freqString').text 'day'
    else if freq == '1'
      $('#freqString').text 'days'
    else if freq == '7'
      $('#freqString').text 'weeks'
    else if freq == '14'
      $('#freqString').text 'every other weeks'
    else if freq == '30'
      $('#freqString').text 'months'
    return

Template.dates.onRendered ->
  ## Loading options for the datepicker
	$('#datepicker').datepicker
    startDate: 'today'
    format: 'yyyy/mm/dd'

Template.newChoreForm.helpers
  users: ->
    if Session.get('suite')?
      Suites.findOne(Session.get('suite')._id).users
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name

