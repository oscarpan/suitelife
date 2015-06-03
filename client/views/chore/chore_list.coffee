Template.choresList.helpers
  activeList: ->
    Session.get 'activeList'
  listData: ->
    list = Session.get 'listData'
    if list == 'upcoming'
      date = moment(moment(new Date).startOf 'day').toDate()
      Chores.find({
        startDate: {$gt: date}
      },
      	sort:
      		startDate: 1
      		createdAt: 1
      )
    else if list == 'all'
      Chores.find {}, sort: 
        startDate: 1
        createdAt: 1
    else if list == 'today'
      date = moment(moment(new Date).startOf 'day').toDate()
      Chores.find({
        $or: [ {startDate: date}, {$and: [ {startDate: {$lt: date}}, {completed: false} ]} ]
      },
        sort:
          startDate: 1
          createdAt: 1
      )
  todayCount: ->
  	date = moment(moment(new Date).startOf 'day').toDate()
  	Chores.find({ 
  		$or: [ {startDate: date}, {$and: [ {startDate: {$lt: date}}, {completed: false} ]} ]
  	}).count()
  upcomingCount: ->
  	date = moment(moment(new Date).startOf 'day').toDate()
  	Chores.find({
  		startDate: {$gt: date} 
  		}).count()
  allCount: ->
  	Chores.find({}).count()

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
      (assignee.profile.first_name.charAt 0) + (assignee.profile.last_name.charAt 0)
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


Template.choreItem.events
  'click .completed': (e) ->
    currentId = @_id
    Meteor.call 'completeChore', currentId, (error, id) ->
      if error
        sAlert.error(error.reason)



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