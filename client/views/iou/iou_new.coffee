Template.iouNew.events 'submit form': (e) ->
  e.preventDefault()
  payer = $(e.target).find('[name=payer]').val()
  payee = $(e.target).find('[name=payee]').val()

  iou =
    payerId:    payer #Not pointing to ID
    payeeId:    payee #Not pointing to ID
    reason:     $(e.target).find('[name=reason]').val()
    amount:     $(e.target).find('[name=amount]').val()
    date:       new Date()

  Meteor.call 'newIou', iou, (error, id) ->
    if error
      return alert(error.reason)
    Router.go 'iouDetail', _id: id
    return

  return