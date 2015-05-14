Template.choreDetail.events
  'click .edit-chore': (e) ->
    e.preventDefault()
    Session.set 'activeModal', 'editChoreForm'
    return

  'click .list-chore': (e) ->
    $('#createChoreModal').modal 'hide'
    Router.go 'choresList'
    return

Template.choreDetail.helpers
  choreEvent: ->
    Session.get 'choreData'