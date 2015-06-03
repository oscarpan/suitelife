Template.iouNew.helpers
  users: ->
    if Suites.findOne(users: Meteor.userId())?
      Suites.findOne(users: Meteor.userId()).users

  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr?.profile?.first_name?
      userName = usr.profile.first_name + " " + usr.profile.last_name

Template.iouNew.events
  'submit form': (e) ->
    e.preventDefault()

    amount = $(e.target).find('[name=amount]').val()

    if ( isNaN amount ) || ( amount < 0 )
      alert "Invalid amount: the amount must be a valid dollar value."
      return
      
    iou =
      payerId:    Meteor.user()._id
      payeeId:    $(e.target).find('[name=payee]').val()
      reason:     $(e.target).find('[name=reason]').val()
      amount:     numeral($(e.target).find('[name=amount]').val()).format('0,0.00')
      paid:       false
      deleted:    false
      editLog:    [ { "lastEdited": new Date( ).getTime( ),
      "logMessage": Meteor.user( ).profile.first_name + " created the IOU \"" +
      $( e.target ).find( '[name=reason]' ).val( ) + "\" for the amount of $" +
      amount + ".",
      "editType":   "create" } ]

    Meteor.call 'newIou', iou, (error, id) ->
      if error
        sAlert.error(error.reason)
      $('#newIouModal').modal('toggle')
      $('#newIouModal').find('input:text').val('')
      Router.go '/'
      return

    return