Template.choresList.helpers chores: ->
  ## display chores in descending order
  Chores.find {}, sort: createdAt: -1

Template.choreItem.events
  'click .listDelete': (e) ->
    e.preventDefault()
    if confirm('Delete this Chore?')
      currentId = @_id
      Meteor.call 'deleteChore', currentId, (error, id) ->
        if error
          return alert(error.reason)
        Router.go 'choresList'
        return
    return
 
