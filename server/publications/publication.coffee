Meteor.publish 'posts', (post_ids)->
	Posts.find {_id: $in: post_ids}

Meteor.publish 'chores', (chore_ids)->
	Chores.find {_id: $in: chore_ids}
	
Meteor.publish 'suites', ->
  Suites.find {}

Meteor.publish 'ious', ->
  Ious.find {}

Meteor.publish 'users', ->
  Meteor.users.find {}