Template.splash.helpers
  inviteRoute: ->
    Router.current().route.getName() == 'invite'
  toDashboard: ->
    Router.go "/"

Template.uhoh.helpers
  isPhone: ->
    Meteor.Device.isPhone()

Template.signup.helpers
  suites: ->
    Suites.find {}, sort: createdAt: -1

Template.jumbotron.events 
  'click .signupButton': (e) ->
    e.preventDefault()
    $.scrollTo $('#signup'), duration: 500
  'click .loginButton': (e) ->
    e.stopPropagation();
    Template._loginButtons.toggleDropdown();

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

  re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
  if !re.test(email)
    sAlert.error "Please fill in a valid email"
    false
  else
    if !first or 0 == first.length or !last or 0 == last.length
      sAlert.error "Please fill in first & last name"
      false
    else
      if !suite_name or 0 == suite_name.length
        sAlert.error "Please fill in a Suite name"
        false
      else
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
              sAlert.error(error.reason)
            else
              #login
              Meteor.loginWithPassword email, password, (error) ->
                if error
                  sAlert.error(error.reason)

              #associate with the invite suite
              if !(/invite\//.exec Router.current()?.url)?
                Meteor.call 'newSuite', {name: suite_name}, (error, id) ->
                  if error
                    sAlert.error(error.reason)
              #or create a new suite
              else
                Meteor.call 'addUserToSuite', suite._id, (error, id) ->
                  if error
                    sAlert.error(error.reason)

              Router.go("/")