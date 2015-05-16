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
  #TODO: send email
  return

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
  ]
