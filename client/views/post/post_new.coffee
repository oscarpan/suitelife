Template.postNew.events 'submit form': (e) ->
  e.preventDefault()
  post = 
    fieldA: $(e.target).find('[name=fieldA]').val()
    fieldB: $(e.target).find('[name= fieldB]').val()
    fieldC: $(e.target).find('[name= fieldC]').val()
    fieldD: $(e.target).find('[name= fieldD]').val()
    fieldE: $(e.target).find('[name= fieldE]').val()
  Meteor.call 'newPost', post, (error, id) ->
    if error
      return alert(error.reason)
    Router.go 'postDetail', _id: id
    return
  return
