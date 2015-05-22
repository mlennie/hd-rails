class ReservationValidationEmailWorker
  include Sidekiq::Worker

  def perform(booking_name, restaurant_name)
  	#get restaurant emails
    emails = Restaurant.find_by(name: restaurant_name).emails
    #split emails into array
    emailArray = emails.split(' ')
    emails.each do |email|
      RestaurantMailer.reservation_validation(booking_name, email).deliver
    end
    AdminMailer.validation_email_sent(booking_name, restaurant_name).deliver
  end
end