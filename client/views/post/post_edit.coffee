Template.postEdit.events
  'submit form': (e) ->
    e.preventDefault()
    currentId = @_id
    postEdits = 
      fieldA: $(e.target).find('[name=fieldA]').val()
      fieldB: $(e.target).find('[name= fieldB]').val()
      fieldC: $(e.target).find('[name= fieldC]').val()
      fieldD: $(e.target).find('[name= fieldD]').val()
      fieldE: $(e.target).find('[name= fieldE]').val()
    Meteor.call 'editPost', postEdits, currentId, (error, id) ->
      if error
        return alert(error.reason)
      Router.go 'postDetail', _id: id
      return
    return
  'click .delete': (e) ->
    e.preventDefault()
    if confirm('Delete this Post?')
      currentId = @_id
      Meteor.call 'deletePost', currentId, (error, id) ->
        if error
          return alert(error.reason)
        Router.go 'postsList'
        return
    return
  'click .cancel': (e) ->
    e.preventDefault()
    Router.go 'postsList'
    return