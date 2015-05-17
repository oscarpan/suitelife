Template.iouNew.helpers
  users: ->
    Suites.findOne({ users: Meteor.userId() }).users

  getUserName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name

Template.iouNew.events 'submit form': (e) ->
  e.preventDefault()
  payer = $(e.target).find('[name=payer]').val()
  payee = $(e.target).find('[name=payee]').val()

  iou =
    payerId:    payer
    payeeId:    payee
    reason:     $(e.target).find('[name=reason]').val()
    amount:     $(e.target).find('[name=amount]').val()
    paid:       false

  Meteor.call 'newIou', iou, (error, id) ->
    if error
      return alert(error.reason)
    Router.go '/'
    return

  return