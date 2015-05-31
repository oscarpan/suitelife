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
        maxHeap.set log.logMessage, log.lastEdited

    while not maxHeap.empty( )
      console.log maxHeap.maxElementId( )
      recentLogs.push { "date": ( new Date maxHeap.get maxHeap.maxElementId( ) ).toLocaleString( ),
      "message": maxHeap.maxElementId( ) }

      maxHeap.remove maxHeap.maxElementId( ) 

    recentLogs