Meteor.startup ->
  process.env.MAIL_URL = 'smtp://postmaster%40suitelife.tk:58a6f91c47d7b82c5a9db38b63c69e70@smtp.mailgun.org:587'
  return


Meteor.methods sendEmail: (to, from, subject, text) ->
  check [
    to
    from
    subject
    text
  ], [ String ]
  # Let other method calls from the same client start running,
  # without waiting for the email sending to complete.
  @unblock()
  Email.send
    to: to
    from: from
    subject: subject
    text: text
  return