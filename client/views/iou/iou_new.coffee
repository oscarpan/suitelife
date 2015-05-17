Template.iouNew.helpers
  users: ->
    Suites.findOne({ users: Meteor.userId() }).users

  getUserName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name

Template.iouNew.events
  'submit form': (e) ->
    e.preventDefault()
    payer = $(e.target).find('[name=payer]').val()
    payee = $(e.target).find('[name=payee]').val()

    iou =
      payerId:    payer
      payeeId:    payee
      reason:     $(e.target).find('[name=reason]').val()
      amount:     $(e.target).find('[name=amount]').val()
      paid:       false

<<<<<<< HEAD
    Meteor.call 'newIou', iou, (error, id) ->
      if error
        return alert(error.reason)
      Router.go 'iouDetail', _id: id
      return
=======
  Meteor.call 'newIou', iou, (error, id) ->
    if error
      return alert(error.reason)
    Router.go '/'
    return
>>>>>>> 24764043269110c7c63342ff1e2b79ec99465944

    return