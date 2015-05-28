Template._loginButtonsAdditionalLoggedInDropdownActions.events 'click #login-buttons-send-invite': (e) ->
  e.preventDefault()
  $('#inviteModal').modal 'show'

Template._loginButtonsAdditionalLoggedInDropdownActions.events 'click #login-buttons-settings': (e) ->
  e.preventDefault()
  $('#settingsModal').modal 'show'

Template.Nav.rendered = ->
  $('[data-toggle="tooltip"]').tooltip placement:'bottom'

Template.settings.rendered = ->
  $('.switch').bootstrapSwitch();

Template.invite.events 'submit form': (e) ->
  e.preventDefault()
  usr = Meteor.user()
  suite = Suites.findOne users: usr._id
  emails = $(e.target).find('[name=email]').val()
  Meteor.call 'sendEmail', emails, 'SuiteLife <suitelife@suitelife.com>', '[SuiteLife] Invitation', usr.profile['first_name']+' '+usr.profile['last_name']+' invited you to join '+suite.name+' on SuiteLife.'+"\n\r"+'Please click on the following link to signup: '+Meteor.absoluteUrl()+'invite/'+suite._id

  $('#inviteModal').modal 'hide'
  return

Template.settings.events 'submit form': (e) ->
  e.preventDefault()
  alert 'Settings Functionality currently not implemented'
  $('#inviteModal').modal 'hide'
  return

Accounts.config
  forbidClientAccountCreation : true