idInUsersList = (id) ->
  splitterUsersList = Session.get "splitterUsersList"
  if splitterUsersList.indexOf(id) == -1
    return false
  return true

#splitterUsersList : array of user IDs
Template.costSplitter.helpers
  users: ->
    if (typeof Session.get("splitterUsersList") == 'undefined')
      Session.set "splitterUsersList", Suites.findOne({ users: Meteor.userId() }).users
    Suites.findOne({ users: Meteor.userId() }).users

  userName: (id) ->
    usr = Meteor.users.findOne id
    userName = usr.profile.first_name + " " + usr.profile.last_name

  splitPercent: (id) ->
    if idInUsersList(id) == false
      return 0
    splitterUsersList = Session.get "splitterUsersList"
    100 / splitterUsersList.length

  splitCost: (id) ->
    if idInUsersList(id) == false
      return 0.00
    Session.get "evenSplitAmount"

  evenSplitChecked: ->
    if (typeof Session.get("evenSplit") == "undefined")
      Session.set "evenSplit", true
      return true
    else
      return Session.get "evenSplit"

  disabled: (id) ->
    if (Session.get("split-user-" + id) == true)
      return ""
    else
      return "disabled"

Template.costSplitter.events
  'change #even-split-checkbox': (event, template) ->
    Session.set "evenSplit", event.target.checked
    return

  'keyup #amount': (event, template) ->
    splitterUsersList = Session.get "splitterUsersList"
    amount = template.find("#amount").value
    Session.set "evenSplitAmount", amount / splitterUsersList.length
    return

  # Uncheck even-split checkbox when user enters input
  'keyup input[name=split-cost]': (e, t) ->
    if Session.get "evenSplit"
      Session.set "evenSplit", false
    return
  'keyup input[name=split-percent]': (e, t) ->
    if Session.get "evenSplit"
      Session.set "evenSplit", false
    return

  # Disable/Enable input boxes
  'change input[name=split-user]': (e, t) ->
    Session.set(e.currentTarget.id, e.target.checked)
    currentId = e.currentTarget.id.slice(11) #splitter-user-id
    splitterUsersList = Session.get "splitterUsersList"

    # Remove user from splitterUsersList
    if e.target.checked == false
      splitterUsersList.splice(splitterUsersList.indexOf(currentId), 1)

    # Add user to splitterUsersList only if box is checked and user is not
    # currently in the array
    else if e.target.checked == true and idInUsersList(currentId) == false
      splitterUsersList.push(currentId)

    Session.set "splitterUsersList", splitterUsersList
    return
