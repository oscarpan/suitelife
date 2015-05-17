Template.iousList.helpers
  ious: ->
    Ious.find({
    $or: [ { payerId: Meteor.userId() }, { payeeId: Meteor.userId() } ]
    })

Template.iouItem.helpers
  users: ->
    Suites.findOne({ users: Meteor.userId() }).users
  userName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name
  dateFormat: (date) ->
    moment(date).format('MMMM Do')
  amountFormat: (amount, payerId, payeeId) ->
    if payerId == Meteor.userId()
      payee = Meteor.users.findOne payeeId
      "<span class='text-success'>" +
        "You owe " + payee.profile.first_name + " " + payee.profile.last_name +
        #" $" + #amount +
        "</span>"
    else if payeeId == Meteor.userId()
      payer = Meteor.users.findOne payerId
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
      return

    return

Template.iouItem.rendered = ->