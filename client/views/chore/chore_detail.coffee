Template.choreDetail.events
  'click .edit-chore': (e) ->
    e.preventDefault()
    Router.go 'choreEdit', _id: @_id
    return
  'click .list-chore': (e) ->
    e.preventDefault()
    Router.go 'choresList'
    return

Template.choreDetail.helpers
  choreEvent: ->
    choreEvent = Session.get('choreData')    