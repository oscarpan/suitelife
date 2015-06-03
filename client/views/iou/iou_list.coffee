Template.iousList.helpers
  ious: ->
    # Find IOUs where the current user is either the payer or the payee, if the
    # IOU has not been deleted, and then return them
    ious = Ious.find({
    $and: [ { $or: [ { payerId: Meteor.userId() }, { payeeId: Meteor.userId() } ] }, { deleted: false } ]
    })

###
Template.iousList.events
  'hidden.bs.modal #newIouModal': (e) ->
    $('#iousModule').draggable(disabled:false)

  'shown.bs.modal #newIouModal': (e) ->
    $('#iousModule').draggable(disabled:true)
    ###

Template.iouItem.helpers
  users: ->
    Suites.findOne({ users: Meteor.userId() }).users
  userName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name
  dateFormat: (date, paid) ->
    if paid
      'Paid'
    else
      moment(date).format('MMM Do')
  amountFormat: (amount, payerId, payeeId) ->
    if payerId == Meteor.userId()
      payee = Meteor.users.findOne payeeId
      if payee.profile.first_name
        "<span class='text-success'>" +
          "You owe " + payee.profile.first_name + " " +
          payee.profile.last_name +
          "</span>"
    else if payeeId == Meteor.userId()
      payer = Meteor.users.findOne payerId
      if payer.profile.first_name
        "<span class='text-danger'>" +
          payer.profile.first_name + " " + payer.profile.last_name +
          " owes you " + #$" + # $" + amount +
          "</span>"
  paidColor: (paid) ->
    "list-group-item-success" if paid
  textColor: (paid) ->
    "text-success" if paid

Template.iouItem.events
  'click .paid': (e) ->
    currentId = @_id
    Meteor.call 'payIou', currentId, (error, id) ->
      if error
        sAlert.error(error.reason)

  'click .delete': (e) ->
    currentId = @_id
    Meteor.call 'deleteIou', currentId, (error, id) ->
      if error
        sAlert.error(error.reason)
      $('#delete' + currentId + 'Modal').modal('hide')
      $('body').removeClass('modal-open')
      $('.modal-backdrop').remove()
      return

    return


  