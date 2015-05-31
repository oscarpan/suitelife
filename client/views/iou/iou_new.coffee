Template.iouNew.helpers
  users: ->
    if Session.get('suite')?
      Suites.findOne(Session.get('suite')._id).users

  getUserName: (id) ->
    usr = Meteor.users.findOne id
    if usr.profile?
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
      amount:     $(e.target).find('[name=amount]').val()
      paid:       false
      deleted:    false
      editLog:    [ { "lastEdited": new Date( ).getTime( ),
      "logMessage": Meteor.user( ).profile.first_name + " created the IOU \"" +
      $( e.target ).find( '[name=reason]' ).val( ) + "\" for the amount of $" +
      amount + ".",
      "editType":   "create" } ]

    Meteor.call 'newIou', iou, (error, id) ->
      if error
        return alert(error.reason)
      $('#newIouModal').modal('toggle')
      $('#newIouModal').find('input:text').val('')
      Router.go '/'
      return

    return