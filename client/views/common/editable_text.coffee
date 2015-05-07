# EditableText.registerCallbacks 
# 	whodunnit: (doc) ->
# 		# console.log doc
# 		# doc = _.extend doc, lastEditor: Meteor.userId()
# 		_.extend doc, lastEdited: Date.now()

EditableText.maximumImageSize = 200000;

EditableText.registerCallbacks whodunnit: (doc) ->
  _.extend doc, lastEdited: Date.now()