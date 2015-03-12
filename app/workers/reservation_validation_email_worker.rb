class ReservationValidationEmailWorker
  include Sidekiq::Worker

  def perform(booking_name, email, restaurant_name)
    RestaurantMailer.reservation_validation(booking_name, email).deliver
    AdminMailer.validation_email_sent(booking_name, restaurant_name).deliver
  end
end