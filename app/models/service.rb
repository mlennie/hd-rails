class Service < ActiveRecord::Base

  include Archiving

  has_many :reservations
  belongs_to :restaurant

  just_define_datetime_picker :start_time
  just_define_datetime_picker :last_booking_time

  before_save :update_current_discount

  def self.get_service params

  	#add service 
    #get restaurant
    restaurant = Restaurant.find(params[:reservation][:restaurant_id].to_i)
    
    #get service based on times
    service = restaurant.services.where(
      "start_time <= :time AND last_booking_time >= :time",
      { time: params[:reservation][:time] }
    ).first

    #update service params
    return service
  end

  #before save or update, adjust current discount
  def update_current_discount
    #get spots already taken
    spots_taken = self.reservations.get_unarchived.where(
                    "status != ?", Reservation.statuses[:cancelled]
                  ).count

    #get percentage availabilites
    number_of_ten_available = self.nb_10
    number_of_fifteen_available = self.nb_15
    number_of_twenty_available = self.nb_20
    number_of_twenty_five_available = self.nb_25

    #get new current discount
    #return 0 if no spots left
    if spots_taken >= self.availabilities
      discount = 0
    #start highest to lowest percentages 
    #to see which percentage is still available 
    elsif spots_taken < number_of_twenty_five_available
      discount = 0.25
    elsif spots_taken < number_of_twenty_available
      discount = 0.20
    elsif spots_taken < number_of_fifteen_available
      discount = 0.15
    else
      discount = 0.10
    end
    self.current_discount = discount
  end
end
