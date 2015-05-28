root = exports ? this
root.Ious = new (Meteor.Collection)('ious')
# Note: this will allow ALL users to insert, update, and delete Ious
Meteor.methods
  deleteIou: (id) ->
    Ious.remove id
  newIou: (iou) ->
    iou.createdAt = (new Date).getTime()
    id = Ious.insert(iou)
    id
  editIou: (iou, editedField) ->
    lastEdited = new Date()
    ## If the amount was changed, build a log message to convey the changes
    if editedField.fieldName == "amount"
      logMessage = Meteor.user( ).profile.first_name + ' changed IOU "' + iou.reason + '"\'s amount from ' +
      iou.amount + ' to ' + editedField.newValue + ' on ' + lastEdited.toDateString() + '.'

    Ious.update iou._id, $set: { "lastEdited": lastEdited.getTime( ) }
    Ious.update iou._id, $push: { "editLog": logMessage } 
  payIou: (id) ->
    Ious.update id, $set: {paid: true}
    id