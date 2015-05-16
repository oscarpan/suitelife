Template.splash.helpers
  inviteRoute: ->
    Router.current().route.getName() == 'invite'

Template.signup.helpers
  suites: ->
    Suites.find {}, sort: createdAt: -1

#if the url has the string "invite/", then fill in the suite
Tracker.autorun ->
  if (/invite\//.exec Router.current()?.url)?
    suite_id = Router.current().url.split("/").pop()
    suite = Suites.findOne suite_id
    $('[name=suiteName]').attr("readonly", "")
    $('[name=suiteName]').val("Suitename: " + suite?.name)

Template.signup.events 'submit form': (e) ->
  e.preventDefault()

  #get targets from form
  email = $(e.target).find('[name=email]').val()
  password = $(e.target).find('[name=password]').val()
  first = $(e.target).find('[name=firstName]').val()
  last = $(e.target).find('[name=lastName]').val()
  #find the exisiting suite
  suite_id = Router.current().url.split("/").pop()
  suite = Suites.findOne suite_id
  #or record the new suites name
  suite_name = $(e.target).find('[name=suiteName]').val()

  #create an account
  Accounts.createUser
    #the user object {email:... password:... profile:....}
    email: email
    password: password 	#accounts will encrypt this for us
    profile:
      first_name: first
      last_name: last
    , (error) ->
      if error
        return alert(error.reason)
      else
				#login
        Meteor.loginWithPassword email, password, (error) ->
          if error
            return alert(error.reason)

				#associate with the invite suite
        if !(/invite\//.exec Router.current()?.url)?
          Meteor.call 'newSuite', {name: suite_name}, (error, id) ->
            if error
              return alert(error.reason)
				#or create a new suite
        else
          Meteor.call 'addUserToSuite', suite._id, (error, id) ->
            if error
              return alert(error.reason)

        Router.go("/")