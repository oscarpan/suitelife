Template.Nav.helpers
  getSuiteName: ->
    ## Find and return suite name
    suite = Suites.findOne users: Meteor.userId( )
    if suite?
      suite.name
    else
      ""
  getSuite: ->
    ## Find and return suite
    Suites.findOne users: Meteor.userId()

half_width = $(window).width() *.45
full_width = $(window).width() *.95
half_width2 = $(window).width() *.47
posts_min_width= 640
posts_min_height= 300
ious_min_width= 565
ious_min_height= 175
cal_min_width= 640
cal_min_height= 300
cal_max_height= 610
chores_min_width= 565
chores_min_height= 175
modules = ['postsModule', 'iousModule', 'calModule', 'choresModule']
bodies = ['postsList', 'iousList', 'choreCal', 'choresList'] 

Template.Nav.events
  'click .postMode': (e) ->
    sizes = [
      {width: full_width, height: posts_min_height + 200, left: 0, top: 0}, 
      {width: full_width - half_width2, height: ious_min_height, left: half_width2, top: posts_min_height + 230},
      {width: half_width, height: cal_min_height, left: 0, top: posts_min_height + 230},
      {width: full_width - half_width2, height: chores_min_height, left: half_width2, top: posts_min_height + ious_min_height + 260}
    ]
    updateModules(sizes, e)
  'click .choreMode': (e) ->
    sizes = [
      {width: half_width, height: posts_min_height, left: 0, top: cal_max_height + chores_min_height + 260}, 
      {width: full_width - half_width2, height: ious_min_height, left: half_width2, top: cal_max_height + chores_min_height + 260},
      {width: full_width, height: cal_max_height, left: 0, top: chores_min_height + 230},
      {width: full_width, height: chores_min_height + 200, left: 0, top: 0}
    ]
    updateModules(sizes, e)    
  'click .iouMode': (e) ->
    sizes = [
      {width: full_width - half_width2, height: posts_min_height, left: half_width2, top: ious_min_height + 230}, 
      {width: full_width, height: ious_min_height + 200, left: 0, top: 0},
      {width: half_width, height: cal_min_height, left: 0, top: ious_min_height + 230},
      {width: half_width, height: chores_min_height, left: 0, top: ious_min_height + posts_min_height + 260}
    ]
    updateModules(sizes, e)

updateModules = (sizes, e) ->
  for i in [0...modules.length]
    do (i) ->
      moduleName = modules[i]
      target = $('#' + moduleName)
      targetBody = $('#' + bodies[i])
      Meteor.call 'updateModuleLocation', moduleName, sizes[i], sizes[i], ->
        location = Meteor.user().modules[moduleName]
        target.width(location.width)
        target.height(location.height)
        target.css('top', location.top)
        target.css('left', location.left)
        targetBody.height(target.height() - 88)

Template._loginButtonsLoggedInDropdown.helpers
  user_profile_picture: ->
    if Meteor.user()
      'http://www.gravatar.com/avatar/' + CryptoJS.MD5(Meteor.user().emails[0].address).toString()+'?d=retro'

Template._loginButtonsLoggedOutDropdown.helpers
  forbidClientAccountCreation: true

Template._loginButtonsLoggedOutPasswordService.helpers
  showCreateAccountLink: false

Template._loginButtonsAdditionalLoggedInDropdownActions.events 
  'click #login-buttons-send-invite': (e) ->
    e.preventDefault()
    $('#inviteModal').modal 'show'
    $('#invite-url').val(Meteor.absoluteUrl()+'invite/'+Suites.findOne(users: Meteor.userId())._id)
    $('#invite-url:text').focus ->
      $(this).select()
  'click #login-buttons-leave-suite': (e) ->

Template._loginButtonsAdditionalLoggedInDropdownActions.events 
  'click #login-buttons-settings': (e) ->
    e.preventDefault()
    $('#settingsModal').modal 'show'

Template.Nav.events
  'click #delete-my-account': (e) ->
    Meteor.call 'deleteAccount', (error) ->
      if error
        console.log error
        sAlert.error(error.reason)

Template.Nav.rendered = ->
  $('[data-toggle="tooltip"]').tooltip placement:'bottom'

Template.settings.rendered = ->
  $('.switch').bootstrapSwitch();

Template.invite.events 
  'submit form': (e) ->
    e.preventDefault()
    usr = Meteor.user()
    suite = Suites.findOne(users: Meteor.userId())._id
    emails = $(e.target).find('[name=email]').val()
    Meteor.call 'sendEmail', emails, 'SuiteLife <suitelife@suitelife.com>', '[SuiteLife] Invitation', usr.profile['first_name']+' '+usr.profile['last_name']+' invited you to join '+suite.name+' on SuiteLife.'+"\n\r"+'Please click on the following link to signup: '+Meteor.absoluteUrl()+'invite/'+suite._id
    $('#inviteModal').modal 'hide'
    return

Template.settings.events 'submit form': (e) ->
  e.preventDefault()
  sAlert.warning('Settings Functionality currently not implemented')
  $('#inviteModal').modal 'hide'
  return
