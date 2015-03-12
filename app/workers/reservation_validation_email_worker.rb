class ReservationValidationEmailWorker
  include Sidekiq::Worker

  def perform(booking_name, email)
    RestaurantMailer.reservation_validation(booking_name, email).deliver
  end
end