Meteor.publish 'posts', ->
  Posts.find {}

Meteor.publish 'chores', ->
  Chores.find {}