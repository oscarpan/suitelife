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
  editIou: (iou, id) ->
    iou.updatedAt = (new Date).getTime()
    Ious.update id, $set: iou
    id
  payIou: (id) ->
    Ious.update id, $set: {paid: true}
    id