Template.iouEdit.helpers
  users: ->
    Suites.findOne({ users: Meteor.userId() }).users

  getUserName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name

Template.iouEdit.events
  'submit form': (e) ->
    e.preventDefault()
    currentId = @_id

    iouEdit =
      payerId:  $(e.target).find('[name=payer]').val()
      payeeId:  $(e.target).find('[name=payee]').val()
      reason:   $(e.target).find('[name=reason]').val()
      amount:   $(e.target).find('[name=amount]').val()

    Meteor.call 'editIou', iouEdit, currentId, (error, id) ->
      if error
        return alert(error.reason)
      return

    return

  'click .delete': (e) ->
    currentId = @_id

    Meteor.call 'deleteIou', currentId, (error, id) ->
      if error
        return alert(error.reason)
      return

    return