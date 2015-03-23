desc "This task is called by the Heroku scheduler add-on to send confirmation reminders"
task :send_confirmation_reminders => :environment do
  puts "sending confirmation reminders..."
  User.send_confirmation_reminder_emails
  puts "confirmation reminders SENT!!"
end