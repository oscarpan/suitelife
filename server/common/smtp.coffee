Meteor.startup ->
  process.env.MAIL_URL = 'smtp://postmaster%40sandbox2b34aad36d5a4a658b8414b518699cbc.mailgun.org:83659187393d7697aa339c60626fd03e@smtp.mailgun.org:587'
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