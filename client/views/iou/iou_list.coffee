Template.iousList.helpers
  ious: ->
    Ious.find({
    $or: [ { payerId: Meteor.userId() }, { payeeId: Meteor.userId() } ]
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
  dateFormat: (date) ->
    moment(date).format('MMM Do')
  amountFormat: (amount, payerId, payeeId) ->
    if payerId == Meteor.userId()
      payee = Meteor.users.findOne payeeId
      if payee?.profile?.first_name?
        "<span class='text-success'>" +
          "You owe " + payee.profile.first_name + " " +
          payee.profile.last_name +
          "</span>"
    else if payeeId == Meteor.userId()
      payer = Meteor.users.findOne payerId
      if payer?.profile?.first_name?
        "<span class='text-danger'>" +
          payer.profile.first_name + " " + payer.profile.last_name +
          " owes you " + #$" + # $" + amount +
          "</span>"
  paidColor: (paid) ->
    "list-group-item-success" if paid

Template.iouItem.events
  'click .paid': (e) ->
    currentId = @_id
    Meteor.call 'payIou', currentId, (error, id) ->
      if error
        return alert(error.reason)

  'click .delete': (e) ->
    currentId = @_id
    Meteor.call 'deleteIou', currentId, (error, id) ->
      if error
        return alert(error.reason)
      $('#delete' + currentId + 'Modal').modal('hide')
      $('body').removeClass('modal-open')
      $('.modal-backdrop').remove()
      return

    return
  