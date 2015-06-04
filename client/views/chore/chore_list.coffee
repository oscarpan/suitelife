Template.choresList.onCreated ->
  # 1. Initialization
  instance = this
  # initialize the reactive variables
  #suite = (Suites.findOne users: Meteor.userId())
  instance.chore_ids = new ReactiveVar([])
  # 2. Autorun
  # will re-run when the reactive variables changes
  @autorun ->
    # get the limit
    suite = (Suites.findOne users: Meteor.userId())
    if suite
      instance.chore_ids.set(suite.chore_ids)

    subscription = instance.subscribe('chores', instance.chore_ids.get())
    
# 3. Cursor
  instance.all = ->
    #suite = (Suites.findOne users: Meteor.userId())
    
    #if suite
     # return Chores.find {_id: $in: suite.chore_ids}
    #else
    return Chores.find({
    	_id: $in: instance.chore_ids.get()
  	},
  		sort:
    		startDate: 1
    		createdAt: 1
    )

  instance.upcoming = ->
  	date = moment(moment(new Date).startOf 'day').toDate()
  	return Chores.find({
  		$and: [ {_id: $in: instance.chore_ids.get()}, { startDate: {$gt: date}} ]
  	},
    	sort:
    		startDate: 1
    		createdAt: 1
    )

  instance.today = ->
  	date = moment(moment(new Date).startOf 'day').toDate()
  	return Chores.find({
  		$and: [ {_id: $in: instance.chore_ids.get()}, { $or: [ {startDate: date}, {$and: [ {startDate: {$lt: date}}, {completed: false} ]} ]} ]      
     },
      sort:
        startDate: 1
        createdAt: 1
    )

Template.choresList.helpers
  activeList: ->
    Session.get 'activeList'
  listData: ->
    list = Session.get 'listData'
    if list == 'upcoming'
    	Template.instance().upcoming()
      #Chores.find({
      #  startDate: {$gt: date}
      #},
      #	sort:
      #		startDate: 1
      #		createdAt: 1
      #)
			
    else if list == 'all'
      Template.instance().all()
      #Chores.find {}, sort: 
       # startDate: 1
        #createdAt: 1
    else if list == 'today'
      Template.instance().today()
      #date = moment(moment(new Date).startOf 'day').toDate()
      #Chores.find({
       # $or: [ {startDate: date}, {$and: [ {startDate: {$lt: date}}, {completed: false} ]} ]
      #},
       # sort:
        #  startDate: 1
         # createdAt: 1
      #)
  todayCount: ->
  	return Template.instance().today().count()
  	#date = moment(moment(new Date).startOf 'day').toDate()
  	#Chores.find({ 
  		#$or: [ {startDate: date}, {$and: [ {startDate: {$lt: date}}, {completed: false} ]} ]
  	#}).count()
  upcomingCount: ->
  	return Template.instance().upcoming().count()
  	#date = moment(moment(new Date).startOf 'day').toDate()
  	#Chores.find({
  		#startDate: {$gt: date} 
  		#}).count()
  	
  allCount: ->
  	return Template.instance().all().count()
  	#Chores.find({}).count()


Template.choresList.events
  'click #todayChores': (e) ->
    e.preventDefault()
    Session.set 'activeList', 'choreItem'
    Session.set 'listData', 'today'

  'click #upcomingChores': (e) ->
    e.preventDefault()
    Session.set 'activeList', 'choreItem'
    Session.set 'listData', 'upcoming'

  'click #allChores': (e) ->
    e.preventDefault()
    Session.set 'activeList', 'choreItem'
    Session.set 'listData', 'all'

  'click #listDeleteDiv .btn': (e) ->
  	e.preventDefault()
  	deleteChore = Chores.findOne(@_id)
  	Session.set 'deleteChore', deleteChore
  	Tracker.flush()   # Force an update or the modal won't find the data correctly
  	$('#deletedChoreModal').modal 'show'

  'focus #listName': (e) ->
  	e.preventDefault()
  	currentId = @_id
  	name = $('.listName-' + currentId).val()
  	Session.set 'listName', name

  'change #listName': (e) ->
    e.preventDefault()
    currentId = @_id
    name = $('.listName-' + currentId).val()

    if name == ''
    	sAlert.error("Chores must have a title.")
    	$('.listName-' + currentId).val(Session.get 'listName')
    	return false

    Meteor.call 'updateChoreName', name, currentId, (error, id) ->
      if error
        sAlert.error(error.reason)
      return
    return

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
  Session.set 'activeList', 'choreItem'
  Session.set 'listData', 'today'

Template.choreItem.helpers
  dateFormat: (date) ->
    moment(date).format('MM/DD/YY')
  assignFormat: (assigneeId) ->
    assignee = Meteor.users.findOne assigneeId
    if assignee?
      (assignee.profile.first_name.charAt(0).toUpperCase()) + (assignee.profile.last_name.charAt(0).toUpperCase())
  highlight: (assigneeId) ->
  	if assigneeId == Meteor.userId()
  		'#F98914'
  	else
  		'#0A7676'
  completeColor: (completed, startDate) ->
    if completed
      "list-group-item-success"
    else
      date = new Date
      date.setDate date.getDate() - 1

      if startDate < date and not completed
        "list-group-item-danger"
  pastDue: (startDate) ->
    date = new Date
    date.setDate date.getDate() - 1

    if startDate < date
      "Past Due!"
    else
      moment(startDate).format('MM/DD/YY')
  users: ->
    if Suites.findOne(users: Meteor.userId())?
      Suites.findOne(users: Meteor.userId()).users
  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
      userName = usr.profile.first_name + " " + usr.profile.last_name
  selected: (assignee, current) ->
    return assignee == current



Template.choreItem.events
  'click .completed': (e) ->
    currentId = @_id
    Meteor.call 'completeChore', currentId, (error, id) ->
      if error
        sAlert.error(error.reason)
  'click #initials': (e) ->
    currentId = @_id
    $('#listEditAssigneeDiv' + currentId).show()
    $('.listEditAssignee .dropdown-menu').show()

   'blur .listEditAssignee': (e) ->
    e.preventDefault()
    currentId = @_id
    assignee = $('#listEditAssignee' + currentId).val()
    
    $('.listEditAssignee').hide()
    Meteor.call 'updateChoreAssignee', assignee, currentId, (error, id) ->
      if error
        sAlert.error(error.reason)
      return
    return

  #'click .statusText': (e) ->
   # currentId = @_id
    #$('#listEditDateDiv' + currentId).show()


Template.choreItem.onRendered ->
  #Template.instance().parent().parent().parent().chore_ids.set((Suites.findOne users: Meteor.userId()).chore_ids)
  $('.selectpicker').selectpicker()

#Template.choreItem.onDestroyed ->
  #Template.instance().parent().parent().parent().chore_ids.set((Suites.findOne users: Meteor.userId()).chore_ids)


Template.deleteChoreModal.helpers
	deletedChore: ->
		deleted = Session.get 'deleteChore'


Template.deleteChoreModal.events	
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