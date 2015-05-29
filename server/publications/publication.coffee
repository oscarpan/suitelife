if Meteor.isServer
	Meteor.publish 'posts', ->
	  Posts.find {}

	Meteor.publish 'chores', ->
	  Chores.find {}

	Meteor.publish 'suites', ->
	  Suites.find {}

	Meteor.publish 'ious', ->
	  Ious.find {}

	Meteor.publish 'users', ->
	  Meteor.users.find {}