Template.choresList.helpers
  activeList: ->
    Session.get 'activeList'
  listData: ->
    list = Session.get 'listData'
    if list == 'upcoming'
      date = moment(moment(new Date).startOf 'day').toDate()
      Chores.find({
        startDate: {$gt: date}
      })
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

  'change #listName': (e) ->
    e.preventDefault()
    currentId = @_id
    name = $('.listName' + currentId).val()
    console.log name
    Meteor.call 'updateChoreName', name, currentId, (error, id) ->
      if error
        return alert(error.reason)
      return
    return 

  'click #comments': (e) ->
  	currentId = @_id
  	$('.comments' + currentId).toggle()



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

Template.choreItem.events
  'click .listDelete': (e) ->
    e.preventDefault()
    if confirm('Delete this Chore?')
      currentId = @_id
      Meteor.call 'deleteChore', currentId, (error, id) ->
        if error
          return alert(error.reason)
        return
    return

  'click .completed': (e) ->
    currentId = @_id
    Meteor.call 'completeChore', currentId, (error, id) ->
      if error
        return alert(error.reason)


