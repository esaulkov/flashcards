# Use this file to easily define all of your cron jobs.
every 1.day, at: '7:00 am' do
  runner "User.notify_about_pending_cards"
end
