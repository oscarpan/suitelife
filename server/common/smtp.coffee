Meteor.startup ->
  process.env.MAIL_URL = 'smtp://jip054%40ucsd.edu:TZi3obu1tPhJiAp5tvjcUg@smtp.mandrillapp.com:587'
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