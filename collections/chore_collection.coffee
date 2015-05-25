root = exports ? this
root.Chores = new (Meteor.Collection)('chores')
# Note: this will allow ALL users to insert, update, and delete Chores
Meteor.methods
  deleteChore: (id) ->
    Chores.remove id
    return
  newChore: (chore, frequency, freqString, freqNum) ->
    console.log chore.startDate
    console.log "frequency " + frequency
    console.log "freqString " + freqString
    console.log "freqNum " + freqNum
    if frequency > 0
      repeating = 0
      incDay = 0
      
      while repeating < freqNum
        startDay = moment(chore.startDate).add incDay, freqString
        chore.startDate = moment(startDay).toDate()

        chore.createdAt = (new Date).getTime()
        console.log chore
        id = Chores.insert(chore)
        
        incDay = 1
        if frequency == 14
          incDay = 2
          
        repeating++
      return
    else
      chore.createdAt = (new Date).getTime()
      id = Chores.insert(chore)
      return

  editChore: (chore, id) ->
    chore.updatedAt = (new Date).getTime()
    Chores.update id, $set: chore
    id
  completeChore: (id) ->
    chore = Chores.findOne id
    isCompleted = chore.completed
    if isCompleted
      Chores.update id, $set:
        completed: false
    else
      Chores.update id, $set:
        completed: true
        completedOn: new Date()
    id