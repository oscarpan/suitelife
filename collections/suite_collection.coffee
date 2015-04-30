root = exports ? this
root.Suites = new (Meteor.Collection)('suites')
# Note: this will allow ALL users to insert, update, and delete Chores
# https://www.discovermeteor.com/blog/meteor-methods-client-side-operations/

Meteor.methods
  deleteSuite: (id) ->
    Suites.remove id
    return
  newSuite: (suite) ->
    suite.createdAt = (new Date).getTime()
    id = Suites.insert(suite)
    user = Meteor.user()
    Meteor.call 'addSuitetoUser', user._id, id, (error, id) ->    #add the user to the new suite
      if error
        return alert(error.reason)    
      return
    id
  editSuite: (suite, id) ->
    suite.updatedAt = (new Date).getTime()
    Suite.update id, $set: suite
    id
  addSuitetoUser: (user_id, suite_id) ->
    suite = Suites.findOne(suite_id)
    if !suite.users                                             #add user to apt user array. no upsert on arrays
      Suites.update suite_id, $set: {users: [user_id]}
    else
      Suites.update suite_id, $push: {users: user_id}
    # Meteor.users.update { _id: user_id }, $set: suite: suite_id #add the apt id to the user
