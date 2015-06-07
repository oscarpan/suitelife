Template.choresList.onCreated ->

  # 1. Initialization
  instance = this
  # initialize the reactive variables
  instance.chore_ids = new ReactiveVar([])
  # 2. Autorun
  # will re-run when the reactive variables changes
  @autorun ->
    suite = (Suites.findOne users: Meteor.userId())
    if suite
      instance.chore_ids.set(suite.chore_ids)

    subscription = instance.subscribe('chores', instance.chore_ids.get())
    
  # Cursor for all chores
  instance.all = ->
  	return Chores.find {}, sort:
    	startDate: 1
    	createdAt: 1
    
  #Cursor for chores past today
  instance.upcoming = ->
  	date = moment(moment(new Date).startOf 'day').toDate()
  	return Chores.find({
  		startDate: {$gt: date}
  	},
    	sort:
    		startDate: 1
    		createdAt: 1
    )

  # Cursor for chores only on today
  instance.today = ->
  	date = moment(moment(new Date).startOf 'day').toDate()
  	return Chores.find({
  		$or: [ {startDate: date}, {$and: [ {startDate: {$lt: date}}, {completed: false} ]} ]      
     },
      sort:
        startDate: 1
        createdAt: 1
    )


Template.choresList.helpers
	# Returns the cursors for the filters
  listData: ->
    list = Session.get 'listData'
    if list == 'upcoming'
    	Template.instance().upcoming()
    else if list == 'all'
      Template.instance().all()
    else if list == 'today'
      Template.instance().today()
  # Returns the counts on the cursors
  todayCount: ->
  	return Template.instance().today().count()
  upcomingCount: ->
  	return Template.instance().upcoming().count()
  allCount: ->
  	return Template.instance().all().count()

Template.choresList.events
	# Each click sets a Session for the listData helper to manage	
  'click #todayChores': (e) ->
    e.preventDefault()
    Session.set 'listData', 'today'

  'click #upcomingChores': (e) ->
    e.preventDefault()
    Session.set 'listData', 'upcoming'

  'click #allChores': (e) ->
    e.preventDefault()
    Session.set 'listData', 'all'

  # To bring up the delete modal when the red 'X' is clicked
  'click #listDeleteDiv .btn': (e) ->
  	e.preventDefault()
  	deleteChore = Chores.findOne(@_id)
  	Session.set 'deleteChore', deleteChore
  	Tracker.flush()   # Force an update or the modal won't find the data correctly
  	$('#deletedChoreModal').modal 'show'

  # Save the name that was in the chore in case of invalid input
  'focus #listName': (e) ->
  	e.preventDefault()
  	currentId = @_id
  	name = $('.listName-' + currentId).val()
  	Session.set 'listName', name

  # When the chore name changes through a list edit
  'change #listName': (e) ->
    e.preventDefault()
    currentId = @_id
    name = $('.listName-' + currentId).val()

    # If the user tries to empty an empty title, throw an error and put the previous title back in
    if name == ''
    	sAlert.error("Chores must have a title.")
    	$('.listName-' + currentId).val(Session.get 'listName')
    	return false

    Meteor.call 'updateChoreName', name, currentId, (error, id) ->
      if error
        sAlert.error(error.reason)
      return
    return

  # When the chore desc changes through a list edit
  'change #listDesc': (e) ->
    e.preventDefault()
    currentId = @_id
    desc = $('.listDesc-' + currentId).val()
    Meteor.call 'updateChoreDesc', desc, currentId, (error, id) ->
      if error
        sAlert.error(error.reason)
      return
    return

Template.choresList.onRendered ->
 	Session.set 'listData', 'today'


Template.choreItem.helpers
	# various formatting for dates and user names
  dateFormat: (date) ->
    moment(date).format('MM/DD/YY')
  assignFormat: (assigneeId) ->
    assignee = Meteor.users.findOne assigneeId
    if assignee?
      (assignee.profile.first_name.charAt(0).toUpperCase()) + (assignee.profile.last_name.charAt(0).toUpperCase())
  # Initials coloration for if a chore is assigned to the current user
  highlight: (assigneeId) ->
  	if assigneeId == Meteor.userId()
  		'#F98914'
  	else
  		'#0A7676'
  # Color for the list background
  completeColor: (completed, startDate) ->
    if completed
      "list-group-item-success"
    else
      date = new Date
      date.setDate date.getDate() - 1

      if startDate < date and not completed
        "list-group-item-danger"
  # Text to show for the date due/completed or past due
  pastDue: (startDate) ->
    date = new Date
    date.setDate date.getDate() - 1

    if startDate < date
      "Past Due!"
    else
      moment(startDate).format('MM/DD/YY')
  # List of the users
  users: ->
    if Suites.findOne(users: Meteor.userId())?
      Suites.findOne(users: Meteor.userId()).users
  # A string of the users name
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name
  # For showing the assigned user during inline edit
  selected: (assignee, current) ->
    return assignee == current


Template.choreItem.events
	# Updates the chore as compelted
  'click .completed': (e) ->
    currentId = @_id
    Meteor.call 'completeChore', currentId, (error, id) ->
      if error
        sAlert.error(error.reason)

  # Brings up the select input for inline edit
  'click #initials': (e) ->
    currentId = @_id
    $('#listEditAssigneeDiv' + currentId).show()
    $('.listEditAssignee .dropdown-menu').show()

  # Updates the chore assignee
  'blur .listEditAssignee': (e) ->
    currentId = @_id
    assignee = $('#listEditAssignee' + currentId).val()
    
    Meteor.call 'updateChoreAssignee', assignee, currentId, (error, id) ->
      if error
        sAlert.error(error.reason)
      return
    $('.listEditAssignee').hide()
    return

  # Brings up the datepicker for inline edit
  'click #dateStatus': (e) ->
    currentId = @_id
    choreEdit = Chores.findOne currentId
    startDay = moment(choreEdit.startDate).format('YYYY/MM/DD')
    $('.datepicker' + currentId).datepicker 'setDate', startDay

    $('#listEditDateDiv' + currentId).show()
    $('#listEditDateDiv' + currentId).focus()

    # When a date is picked, it is updated and the datepicker is hidden
    $('.list-datepicker').on 'changeDate', (event) ->
      newDate = $('.datepicker' + currentId).datepicker 'getDate'
      Meteor.call 'updateChoreDate', newDate, currentId, (error, id) ->
        if error
          sAlert.error(error.reason)
        return
      $('#listEditDateDiv' + currentId).hide()
      return

  #  Hides the datepicker if no date is chosen but someone clicks outside of the datepicker
  'blur .listEditDate': (e) ->
    currentId = @_id
    $('.listEditDate').hide()
  	
# Set up multi select and datepicker
Template.choreItem.onRendered ->	
	$('.selectpicker').selectpicker()
	$('.list-datepicker').datepicker
    format: 'yyyy/mm/dd'


Template.deleteChoreModal.helpers
	# Data context for delete modal
	deletedChore: ->
		deleted = Session.get 'deleteChore'

Template.deleteChoreModal.events	
	# Deletes the chore
  'click .listDelete': (e) ->
    e.preventDefault()
    currentId = @_id
    Meteor.call 'deleteChore', currentId, (error, id) ->
    	if error
    		sAlert.error(error.reason)
    	$('#deletedChoreModal').modal 'hide'
    	$('#createChoreModal').modal 'hide'
    	return
    return