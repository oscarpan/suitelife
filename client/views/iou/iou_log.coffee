Template.iouLog.helpers
  logMessages: ->
    ious = Ious.find({
    $or: [ { payerId: Meteor.userId() }, { payeeId: Meteor.userId() } ]
    }).fetch( )

    recentLogs = [ ]
    maxHeap = new MaxHeap (a, b) -> return a - b

    for iou in ious
      logs = iou.editLog
      for log in logs
        maxHeap.set { "logMessage": log.logMessage, "editType": log.editType },
        log.lastEdited

    while not maxHeap.empty( )
      recentLogs.push { "date": ( new Date maxHeap.get maxHeap.maxElementId( ) ).toLocaleString( ),
      "message": maxHeap.maxElementId( ).logMessage, "editType": maxHeap.maxElementId( ).editType }

      maxHeap.remove maxHeap.maxElementId( ) 

    recentLogs
  getStyling: ->
    if this.editType == "delete"
      "bg-danger"
    else if this.editType == "create"
      "bg-info"
    else if this.editType == "update"
      "bg-warning"
    else if this.editType == "payed"
      "bg-success"
  getDate: ->
    new Date( ).toLocaleString( )
  getDefaultMessage: ->
    "There are no IOU log messages yet."
