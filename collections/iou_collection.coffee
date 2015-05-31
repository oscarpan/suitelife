root = exports ? this
root.Ious = new (Meteor.Collection)('ious')
# Note: this will allow ALL users to insert, update, and delete Ious
Meteor.methods
  deleteIou: (id) ->
    iou = Ious.findOne id
    Ious.update id, $set: { deleted: true }
    lastEdited = new Date( ).getTime( )
    logMessage = Meteor.user( ).profile.first_name + " deleted IOU \"" + iou.reason + ".\""

    Ious.update id, $push: { "editLog": { "lastEdited": lastEdited,
    "logMessage": logMessage,
    "editType": "delete" } }
  newIou: (iou) ->
    iou.createdAt = (new Date).getTime()
    id = Ious.insert(iou)
    id
  editIou: (iou, editedField) ->
    lastEdited = new Date( ).getTime( )
    ## If the amount was changed, build a log message to convey the changes
    if editedField.fieldName == "amount"
      logMessage = Meteor.user( ).profile.first_name + ' changed IOU "' + iou.reason + '"\'s amount from $' +
      iou.amount + ' to $' + editedField.newValue + '.'
    else if editedField.fieldName == "reason"
      logMessage = Meteor.user( ).profile.first_name + ' changed IOU "' + iou.reason + '" to "' +
      editedField.newValue + '."'

    Ious.update iou._id, $push: { "editLog": { "lastEdited": lastEdited,
    "logMessage": logMessage,
    "editType":   "update" } }
  payIou: (id) ->
    iou = Ious.findOne id
    Ious.update id, $set: {paid: true}
    lastEdited = new Date( ).getTime( )
    logMessage = Meteor.user( ).profile.first_name + " payed IOU \"" + iou.reason + ".\""
    Ious.update id, $push: { "editLog": { "lastEdited": lastEdited
                                          "logMessage": logMessage
                                          "editType": "update" } }
    id