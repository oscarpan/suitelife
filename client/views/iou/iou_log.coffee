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
        maxHeap.set log.lastEdited, log.logMessage

    while not maxHeap.empty( )
      recentLogs.push { "date": ( new Date maxHeap.maxElementId( ) ).toLocaleString( ), "message": maxHeap.get maxHeap.maxElementId( ) }

      maxHeap.remove maxHeap.maxElementId( ) 

    recentLogs