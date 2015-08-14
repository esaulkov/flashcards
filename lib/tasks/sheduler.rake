desc "This task is called by the Heroku scheduler add-on"
task :send_notifications => :environment do
  User.notify_about_pending_cards
end
