root = exports ? this
root.Suites = new (Meteor.Collection)('suites')
# Note: this will allow ALL users to insert, update, and delete Chores
# https://www.discovermeteor.com/blog/meteor-methods-client-side-operations/
#http://stackoverflow.com/questions/4214731/coffeescript-global-variables

Meteor.methods
  deleteSuite: (id) ->
    Suites.remove id
    return
  newSuite: (suite) ->
    suite.createdAt = (new Date).getTime()
    suite_id = Suites.insert(suite)
    Meteor.call 'addUserToSuite', suite_id, (error) ->    #add the user to the new suite
      if error
        sAlert.error(error.reason)   
    Meteor.call 'initializePosts', suite_id, (error) ->
      if error
        sAlert.error(error.reason)
    Meteor.call 'addSweetyTheCat', suite_id, (error) ->
      if error
        sAlert.error(error.reason)
  editSuite: (suite, id) ->
    suite.updatedAt = (new Date).getTime()
    Suite.update id, $set: suite
    id
  addUserToSuite: (suite_id) ->
    suite = Suites.findOne suite_id
    if !suite.users?                                            #add user to apt user array. no upsert on arrays
      Suites.update suite_id, $set: {users: [Meteor.userId()]}
    else
      Suites.update suite_id, $push: {users: Meteor.userId()}
  uploadToSuite: (file_info, suite_id) ->
    suite = Suites.findOne(suite_id)
    if !suite.uploads  
      Suites.update suite_id, $set: {uploads: [file_info]}
    else
      Suites.update suite_id, $push: {uploads: file_info}
  addSweetyTheCat: (suite_id) ->
    sweety = Meteor.users.findOne emails: $elemMatch: address: 'sweetysuitelife@gmail.com'
    if !sweety?
      sweety_id = Accounts.createUser
        email: "sweetysuitelife@gmail.com"
        password: "sweetythecat" 
        profile:
          first_name: "Sweety"
          last_name: "The Cat"
      Suites.update suite_id, $push: {users: sweety_id}
    else
      Suites.update suite_id, $push: {users: sweety._id}
  removeUserFromSuite: (suite_id, user_id) ->
    suite = Suites.findOne suite_id
    users = suite.users
    index = users.indexOf user_id
    if (index > -1)
      users.splice(index, 1)
    Suites.update suite_id, $set: {users: users}
