Template.choreDetail.events
  'click .edit-chore': (e) ->
    e.preventDefault()
    Session.set 'activeModal', 'editChoreForm'
    return

Template.choreDetail.helpers
  choreEvent: ->
    Session.get 'choreEvent'
  date: (date) ->
    moment(date).format('MMMM Do YYYY, h:mm:ss a')
  assignFormat: (assigneeId) ->
    assignee = Meteor.users.findOne assigneeId
    assignee.profile.first_name + " " + assignee.profile.last_name
    
Template.choreDetail.onRendered ->
  $('#datepicker').datepicker
    format: 'yyyy/mm/dd'