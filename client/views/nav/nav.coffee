Template._loginButtonsAdditionalLoggedInDropdownActions.events 'click #login-buttons-send-invite': (e) ->
  e.preventDefault()
  $('#inviteModal').modal 'show'

Template.Nav.rendered = ->
  $('[data-toggle="tooltip"]').tooltip placement:'bottom'

Template.invite.events 'submit form': (e) ->
  e.preventDefault()
  usr = Meteor.user()
  suite = Suites.findOne users: usr._id
  emails = $(e.target).find('[name=email]').val()
  Meteor.call 'sendEmail', emails, 'SuiteLife <suitelife@suitelife.com>', '[SuiteLife] Invitation', usr.profile['first_name']+' '+usr.profile['last_name']+' invited you to join '+suite.name+' on SuiteLife.'+"\n\r"+'Please click on the following link to signup: '+Meteor.absoluteUrl()+'invite/'+suite._id

  $('#inviteModal').modal 'hide'
  return

Accounts.config
  forbidClientAccountCreation : true

Accounts.ui.config
  requestPermissions: {}
  extraSignupFields: [
    {
      fieldName: 'first-name'
      fieldLabel: 'First name'
      inputType: 'text'
      visible: true
      validate: (value, errorFunction) ->
        if !value
          errorFunction 'Please write your first name'
          false
        else
          true
    }
    {
      fieldName: 'last-name'
      fieldLabel: 'Last name'
      inputType: 'text'
      visible: true
      validate: (value, errorFunction) ->
        if !value
          errorFunction 'Please write your last name'
          false
        else
          true
    }
    {
      fieldName: 'suite'
      fieldLabel: 'Suite Name'
      inputType: 'text'
      visibile: true
      saveToProfile: false
      validate: (value, errorFunction) ->
        if !value
          errorFunction 'Please enter the name of your new suite'
          false
        else
          true
    }
  ]
