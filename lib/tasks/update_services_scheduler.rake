desc "This task is called by the Heroku scheduler add-on to add one year's worth of services for all restaurants"
task :update_services_for_year => :environment do
  puts "updating services for all restaurants for whole year"
  Restaurant.add_services_for_restaurants_if_first_of_month
  puts "all services updated"
end