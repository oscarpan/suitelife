Template._loginButtonsLoggedInDropdown.events 'click #login-buttons-edit-profile': (event) ->
  Router.go 'profileEdit'
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
